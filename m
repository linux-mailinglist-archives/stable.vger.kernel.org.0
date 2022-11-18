Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60A462FE49
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 20:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbiKRTuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 14:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiKRTuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 14:50:13 -0500
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B9CA0319;
        Fri, 18 Nov 2022 11:50:12 -0800 (PST)
Received: from pps.filterd (m0098572.ppops.net [127.0.0.1])
        by mx0b-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AIEPBJt001247;
        Fri, 18 Nov 2022 11:49:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=Ytv7dQNGaBtsjfOCgSeLLsv6Q5dxpRWg7EkWwaDJkoU=;
 b=RY0OSmtds4f4mH576JaUVVoi3uvTJCrBs3T++q5Dlg2JD468TBnFlgr6gCX3Mz5DCcKL
 LuQJ+H491LHunJ1QweTvnjag2m3cYePPs99oxs7jKlX2zJ4a4werOvEaD3E5M2kL5zwd
 tCb6vzO0q2utlM1M1puXJmnxNozMOw0rwBqGkvJMkNOVli/qHc3TsbqZ5JSh4/nGLlON
 7BdH/tqKkFmP3nqpYB1pcXhA47J5b8Eq/svFRExBufbhe3c8EJwKGbkBa8D0kirctfCn
 R+IQaXpq12px0ut1k+nKicrD/N8c86ndMrWnfPggHL4TQztfxOSCj3DrHlqZrbsPDpHS 6Q== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0b-00230701.pphosted.com (PPS) with ESMTPS id 3kx0muv5nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 11:49:52 -0800
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5B94240141;
        Fri, 18 Nov 2022 19:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1668800991; bh=Ytv7dQNGaBtsjfOCgSeLLsv6Q5dxpRWg7EkWwaDJkoU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Seq/rgs8MVOCcg63E0LLmoI4SAUUINdrJu1zN1ZebVb8W3GXQoADJ5pHSLk+2c0xG
         /wo7o926ULcEUTCTfjYp88MaxATqlyX4HGSfIXakcA7hFswoFmA3xjvkQSzwU6JvCY
         uzapQMGhFwCwTCbJzodEhCfXUtS65p9Z0gOyy+1zvNQe5/GHdcOZsOVQ/5e6YJyawf
         X2d1OwtavANetPtjJAm5wFdBFY2LfSwBwv77O/5Db7o3ihMI+FOBYweNF+JWCAk4Fv
         ipQjZjnPfbKJtlJUNNHdb1ClBSq1Kg3pvD1F+IiPT7P9FuDRp2nYX2d2g4DM0cH5Vv
         D09az7YKStPkQ==
Received: from o365relay-in.synopsys.com (sv2-o365relay7.synopsys.com [10.202.1.143])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id D2C70A026F;
        Fri, 18 Nov 2022 19:49:48 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id CFA98A08E6;
        Fri, 18 Nov 2022 19:49:46 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0NRTo2Zd4gLCltxeObvym3bZ4nkxX9c006IG0J6Wq1hCLyn1bkJwkNLzBj7iHe9/8kynJyPUHprTtX0mgfNXWQiNchkAqpLMI+jEoS/Tu9kLl03tZQk2I/yj0QRKDzSQUpaox/9Bk3ttZnm40r9LsCdBkF4P+dcl5qqzJnxT755PaTg4DH67Le9pReZXDzMPZzrotEgdr6jwediEIdAHdRs/YAcTS2FcddamchhWIT0MT+MJHuJiPrB48Ghep7kJreiLNYv3dpGB8ndG1ZesA2IGt+KPjbgOA2hHgiOFY8ZnLgZYuNwhcEq1QhAdzHD9t+zASqSdMRKpMnpLyFnXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ytv7dQNGaBtsjfOCgSeLLsv6Q5dxpRWg7EkWwaDJkoU=;
 b=bwRty31s9O2U0ljzgcYkVuDkX7OvPiXuS+Mz4yriTo/i6Ob5whk/LqlrUUBFaTq4l1WX+qXRShMf9hejalMCEcXJqvVAPNmrofd5rs/pvtWFFry5PYUD5ljrjcNBxnPJ8dhLwe+kNSrQ0Q6x87nf4/iZWCePYNYrbat1n+/WyTUk4IJlcYKx/3wyMIFOi1WXnX1M4wj3+93RaWYdt9pDTr/U1AuvJZdDY9GrIWibBlUqlw2VLksyBa6iuArmwl9zvmI8iGd9iRPk5RACSdGVGBK1kkWLDe5icZjy7ePZg2EgAtJ54h8PFx0GhXhPSF76i0SSVavcV3Kq8LxWGHps/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ytv7dQNGaBtsjfOCgSeLLsv6Q5dxpRWg7EkWwaDJkoU=;
 b=aF914GyYrXg8H+b8hBRr8JJ2E5Hafswl07HGBMph6J8/iWnVKA0MSFIr2H58Pynibfq8uVFObycJ6X7zKltOoaj0/unnR0akfJ8yHpeXJJc4cwIaA9wlpdRNCSERdSAsQ/FKZyyLKh+XJxJrof+DBPFSgKSPKyRBF+4d8Xko39s=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by MN2PR12MB4143.namprd12.prod.outlook.com (2603:10b6:208:1d0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Fri, 18 Nov
 2022 19:49:45 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::9f62:5df9:ad93:5a1f]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::9f62:5df9:ad93:5a1f%2]) with mapi id 15.20.5813.020; Fri, 18 Nov 2022
 19:49:45 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Ferry Toth <fntoth@gmail.com>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Ferry Toth <ftoth@exalondelft.nl>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] usb: dwc3: core: defer probe on ulpi_read_id
 timeout
Thread-Topic: [PATCH v3 2/2] usb: dwc3: core: defer probe on ulpi_read_id
 timeout
Thread-Index: AQHY+sbTaif1syI3uUCmhS3xW6I+8K5D8HuAgACspoCAAHseAA==
Date:   Fri, 18 Nov 2022 19:49:44 +0000
Message-ID: <20221118194942.2ixdmxycb5w5z63h@synopsys.com>
References: <20221117205411.11489-1-ftoth@exalondelft.nl>
 <20221117205411.11489-3-ftoth@exalondelft.nl>
 <20221118021107.3uhixtck6sawluoy@synopsys.com>
 <53dde473-2e88-7f51-7417-fce3a73fb8c8@gmail.com>
In-Reply-To: <53dde473-2e88-7f51-7417-fce3a73fb8c8@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|MN2PR12MB4143:EE_
x-ms-office365-filtering-correlation-id: 678cad81-77f0-4357-6a46-08dac99e0ada
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jw9eP40CcZD5K7JDnmXMtO0FkTbZky5flc4uh+Y1Hy3QOrvBGgduGH+n+DbT9juUGnnkYhGG/kQ9Jv2Y/U16aO+EA7Q/4HkIg8hTRqrXudj7rV7oeci3H+brDXY+RlEnOESrAF15Sine0j1j/+rebtTLj01mGhQKJLRqdRAodt9w4PtbA4G3N6onvYMNLc0OltdWK3d3GkWvEVlwNZhCrx7y61a18dvnuL3Zs7s6sRnab3Kg8voKhW1QAnnUqXBA8pgw++ScEeWZfsoHynhr0yRv84McR1ArgyDz7kmVpaRB8lEQIGiwN2jm0KRtxh+aXrv3NeTFEDeJzy784Y+GdgqCq9Ggx/9LmqM9WrQMnwwmvcfw9x80AlmH+YSGQkKukRvZhnIa/iQxgNd2Q0DqBq8Eu6VlZip5LUnZ1VOJnR4vQoTnXH8veHcbYz09krvEdd5qwlaBwTChGJYBE54BDpNT/inKSAQ3UbcBkHumG95H3p2qaIVI8/PZOuAjCS2sPp+Gqo5gwAECmH/3b4nEUi78k1J6dXxst0iP6AOLptoLz5Dw5NaIgwaYvm+c7pFD9odgwARfTRMlZuRNY4/lZ1S0ZyXfmdSrugVajzX1v6YLrpjQrOmm6vBvfM7K3ge3WeD5T+ZtAi7mtrmr118DcXDiuBstZgDzj2Gp+FcBZZI2lsQhiHguu48YK/Vr3MOmnOGfBK4Jjlkx9+LOR4Hmlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199015)(86362001)(76116006)(36756003)(66946007)(186003)(2616005)(41300700001)(66446008)(64756008)(66556008)(8676002)(66476007)(5660300002)(7416002)(4326008)(8936002)(478600001)(316002)(6486002)(71200400001)(1076003)(6916009)(6512007)(122000001)(53546011)(54906003)(6506007)(26005)(38070700005)(38100700002)(2906002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3k3eENiUEFWSXJGZ0RyWVFLUTlLVXdTSy9pNGE3RFFYZXMxSERFWU0vbVJq?=
 =?utf-8?B?eFlaMGJTOGE5YVdGblppOXk1WmdPNGVIbVFBUXNEZDBMZE42SFB5WmtRTHh0?=
 =?utf-8?B?OEFwb1M1V3VMa2tncVNCSTFxUFRFdEdMSlhkZ3ZxN1loa0dyQzl4dFdlejFY?=
 =?utf-8?B?WlJhc0VPM1JlYmc1eXZTbXBSeTIxWGJGblBReVpwMktheWxQOXFjWVdsQjFE?=
 =?utf-8?B?SEVQTUQvOER4ZlFLMGV6dTZ5YlNIMnlsbytSRzQwN2RLaS81ME50Y2pWVnBm?=
 =?utf-8?B?d2pVbit4aVREUWEzZmpwSzQ5TXQydkp0SVpYS2N2Q2R3Qit4WWloanlndFYx?=
 =?utf-8?B?MlVjNi9sWFJVeFM5LzlDTlNOc0JsZkNpVFNGcE9Hd2wxTlZubUg0Rms4eUIr?=
 =?utf-8?B?WklnTmQ3NEpjUjRkQVpkN3FYblRXVmVxbFRCMUN4MnVVWjB6ZUViaVcrZFRF?=
 =?utf-8?B?eEtSaE5GL0tPSUxVWDVkZ0JQcGhDbGhwUStvQVNqdUVNOVVLcTdnOVVwQVhL?=
 =?utf-8?B?SC8zYjFYM1F3aXdWUjhwS2N1UU9nTVVOSlBnSEhPUEJMQ2VLYzhnN3Bnc0ZH?=
 =?utf-8?B?VnRFc3Y2NndiK1BubzlwL2NveTJsV01PTHUyQ1BCUkxmS2JLejBJd0g1REVW?=
 =?utf-8?B?emgrZ0xqZnB6OGpxb2N2Z1ZRUlA5azVwZUpPQTM0MHo2NkZvWnpzNU5LdmI0?=
 =?utf-8?B?cDhJYmczVWdMVmZJaDJTajZHUHYwb2paQUdvaWYvdmpycjh3aHp2cXFPS2U4?=
 =?utf-8?B?QVNhRmhlUlp1eWFMeWFjbmxkbnJ0WEpETk40RjJYc0gza0RZMXlzK29ZRmhW?=
 =?utf-8?B?bzlZbjVISEd3aUZmOElHbjE1LzhwRFRYVFpHUEt1NFBMU3NjREFicnhYZ3pj?=
 =?utf-8?B?WGdxbHg1RUhsVzhOVVNXd1NvTjdsR1crUVd2L0IzeGE3QXgzNUN3OE53eS85?=
 =?utf-8?B?dkl2QUxFcWM3SmFJQjFqZ2F3WFB1RlN3MS9XakhpbHQrbU1sWjhxaTZzQW9r?=
 =?utf-8?B?NnMreXJCSmpmbmhkWGRuVStLLzViRDdoaDJDa1JSSGMvUUU3elJGN0xjV21M?=
 =?utf-8?B?eWdoVktEVWlZb2xCUnNsVDd2OVBQSFhoaXNQVTRuc2FYSXQrdW9PZTFUV2xH?=
 =?utf-8?B?UWRDaHR5dkxCbVNzdXExbHlGTEpOVVBwWDI2SlJSL01FWXB2Z1k1cjFkQm9l?=
 =?utf-8?B?bzh0dFpnMWt1TEtLZndkWCswVzM1VGdaSW5jbzZPUmZydHdqUnVaaW1wMzNY?=
 =?utf-8?B?N0tYM3E4ZkpiWjMyNldBdE5PMVBtYnZ1N0o4VlM3SEFTOXd0TEZ0bFRWZzBD?=
 =?utf-8?B?TVgyT3N3N1Rjd2ZiQVBPMVlsWEJJbW9QY0F5L1RCVmUzc2RXRVNnWXdmVEYw?=
 =?utf-8?B?L3J0eEFLcnlLWFFmckgxYlFCN2M3U0lUdE1xaG9OS3BwbG8vWWVlUTRCTWdO?=
 =?utf-8?B?N1RKWXNQaVczMmcrM3FzRFUybmRGamFaUS9nYzBQQjlGTS9BWjJZaDJ0OHo1?=
 =?utf-8?B?dWRXYytXM25VZ3lSOGNOR2dtWmRjci9NSjZObEVwa1FseVJScUJPUG5STjR5?=
 =?utf-8?B?UEFobkNkRk1YQUVlWGJ4UytJMmxmSUtJZm4wQy82aGFpaTdLc05KcTJDNXhr?=
 =?utf-8?B?RE9NZW1qeDZxRTlzWkVRbzVMejR3OUlUdExKaExHd3RueHVXWlY1VnpVOG5s?=
 =?utf-8?B?YzJjNXQ0ZHpsQ3BXMGdHaUlralVBV1B1WEJBZXlON3RYUG5mb01DcFpPejBX?=
 =?utf-8?B?UmN6R01CWlB3SXNsZUVudGo1bS9NQVVPOEoyYlhKN1UzZkhON2RvRStaUkVV?=
 =?utf-8?B?WWRiNGJkN1NTRWFCZkY1dzZxQkl4WndUMFg1VDBNYTB5QXBQOHlCTDNsSmc2?=
 =?utf-8?B?dFBuY0w5S3ZtY2gzSTFwcG1EMUxEM0pFR2xmUHN6Z3doQVRxRmozRDZwbkZZ?=
 =?utf-8?B?NllaY2RNdmZKekNNd0ZuQlhobkFla3BINWdmSWo2S3lERXF1Tnh2ZE16Rk8y?=
 =?utf-8?B?RGdQaTZzZ1g2NzZQYmV5TXJkMjljN1dPL0dyWlVuQmxFU2l1SFcvNkJMRzRG?=
 =?utf-8?B?UkVBZC9ZTDVMVUJ3bW5USjRFN1duZG00dVIvT2lYUFRoRnpLdUVhb1lEMkEr?=
 =?utf-8?Q?Sw/Rlde4QNI1SnEtXiLt72ZvR?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <41FE24EBE645E749AE2034FD427D4E99@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VUVQUXJmOTlsK0ZkbUxkL2REQ2lTQU5oZXI3V2N5ZGNKMTZoSnVhOXlvK0Vy?=
 =?utf-8?B?SElaeXhoeW5QYlVWZm5TUHJjMnZPWXdVRVRVVHBLbFRqaldkV1p6TTVhU081?=
 =?utf-8?B?c1NQSlVpZ09jR1JYK3NiVi92M0cyWlJsMWE5eHpiRFZtTEF3WHdKZEdxaWEw?=
 =?utf-8?B?eXV4UStaMjhjM3JOWDZXaE5Kell0NWNjcmhNYlNjckwvWFdpRzZQcmZVaHd1?=
 =?utf-8?B?Q25pK2hGeUU2YmdkdDJVblFoQStmQjBaZWo5K01EUVk0amFmZWs4aDRFOWhy?=
 =?utf-8?B?aVY5czhQVUQzNDJ4T05wNjZNMU4zSGI0d1dZMjVjRjVVeUIrQzQxMkM1SEFS?=
 =?utf-8?B?Z1UvM3NZcjR3QzlWRkR4UkZsZU9uOG5jV21oNEVEa016ak9TWFpicDVjT2VD?=
 =?utf-8?B?dytIYmYycU1nbXMvYmRwVmIrWEtmTWM2aXJ1OWVkNVZYZUVEZzNIVk9reFB2?=
 =?utf-8?B?bEs2cjZ2anh3ZE1SUVNoZEJwRzczYkhGR052c1JMUkFQT2Z4WWk3Umc1WUw1?=
 =?utf-8?B?cTR6eWUvdnNPWHBVMjRUekNaMFF1WllPK0R2T3A0WGxyODIvQk1VYnlLNCtP?=
 =?utf-8?B?bTFGakxqMVlXaitkcDNPSlFlNVNmWVVrbDNXVEs4ZjhPazlPRzUxY1NmUXVK?=
 =?utf-8?B?aWllNDFvNkxqSEFFSjQ1MVNTTGY2YzE3T25GeEdMMFNsKzcwd3pFR1A3WWJq?=
 =?utf-8?B?VWNQbnFPaW5ycFR1dEFrM0Jma054WCswSXB0VEtLZDlVNmxZdUVuTnU3U3FB?=
 =?utf-8?B?Z2RUbmNaVWtlMU1PSCt6MzNha1RndW9iUnhmeWlOYllFSDJtb0ZmUlFCQVNS?=
 =?utf-8?B?QW5CR1FXSU1LQTNidmpMR0FydTFCQTZTRzB4a3NiZWN3U0Fydm10cGFwYlg3?=
 =?utf-8?B?cEY1cnRRYnk5RjJQc2JYWjJmeFh6NGVWaXd2azRiQ2RLeTNvdWwweFJ1d3Av?=
 =?utf-8?B?MjdYcCtKVVIrbVFOeEtjZjgrYVBUMCtyMnFDK1lEZ1ZFZ2V6b3o3Skp4ZTU3?=
 =?utf-8?B?VGZTSEE1YlhKcWQ4cXlJU2FndUM4cFFZWWRUMW8rVUJUQ2kraU9Jc0I0c0xE?=
 =?utf-8?B?bU5yeXY2ZGRHdkVGbEkyRTRwaitVcW1LWTg2cTN5bG8yUXhwOEZHejdLUHBy?=
 =?utf-8?B?aWtkL2ZjYzcxZ3hBUE1wT3JJdTJINjZ5WDBITVVqL29wclJ4T3FSZHBoZ2xr?=
 =?utf-8?B?RFNzRWJPR1lkMnZnT3ViQUNSMVpiVTBBd2FBQklWUkljSWEwL0pUdnVjRG8z?=
 =?utf-8?B?Q1g5NVRmblZSNldtYldaUTRkekxHTzlNbmMwc0dBZ2ptSHNuMndYb1ZUQVpV?=
 =?utf-8?B?N0hWU1ZWSnd2b2d5NWhLT09UK25jeUZZb1Z2aWswL1h2NEFWWEhsNnZLQkNE?=
 =?utf-8?B?VC94cThjSDhPc01rWTVDc2R6TndBYitSUFNldDVOZUgxZC9rTXBvTUVack9E?=
 =?utf-8?B?RGxEa3hteTg4bThoMTVqdHI3RUV6MUhyYjFVZTc1cWowZ1VHbnduMVNMWG5y?=
 =?utf-8?B?SGFrLzVOMjZnNW04ejBtdkRidXNMK3Q2NHVqR01iVVdXbFg0QkNFZ21XajI3?=
 =?utf-8?Q?pAxiAoDtrgw54LMiPF10sU0Ig=3D?=
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 678cad81-77f0-4357-6a46-08dac99e0ada
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 19:49:45.0292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vLmMS5idlaoec3l6FIOPnT8S0wSIAYklut8vEbeKe7U7ABkV0udb+EFHDnYENRNVzPycDrcVek5XUdhfAFBV+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4143
X-Proofpoint-ORIG-GUID: XsuW2HVFgS5DjApZpbut75mSyfYd6Ms5
X-Proofpoint-GUID: XsuW2HVFgS5DjApZpbut75mSyfYd6Ms5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-18_06,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 mlxscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501 suspectscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211180118
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCBOb3YgMTgsIDIwMjIsIEZlcnJ5IFRvdGggd3JvdGU6DQo+IA0KPiBPbiAxOC0xMS0y
MDIyIDAzOjExLCBUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+ID4gT24gVGh1LCBOb3YgMTcsIDIwMjIs
IEZlcnJ5IFRvdGggd3JvdGU6DQo+ID4gPiBTaW5jZSBjb21taXQgMGYwMTAxNzENCj4gPiBJIGRv
bid0IHlvdXIgdXBkYXRlIGFzIG5vdGVkIGluIHRoZSB2MyBjaGFuZ2UgKGllLiBHcmVnJ3Mgc3Vn
Z2VzdGlvbnMpLg0KPiANCj4gSW5kZWVkLiBJIHNlZW0gdG8gaGF2ZSBzZW50IGluIHRoZSB3cm9u
ZyBzaGEuIFNvcnJ5IGFib3V0IHRoaXMuDQo+IA0KPiA+ID4gRHVhbCBSb2xlIHN1cHBvcnQgb24g
SW50ZWwgTWVycmlmaWVsZCBwbGF0Zm9ybSBicm9rZSBkdWUgdG8gcmVhcnJhbmdpbmcNCj4gPiA+
IHRoZSBjYWxsIHRvIGR3YzNfZ2V0X2V4dGNvbigpLg0KPiA+ID4gDQo+ID4gPiBJdCBhcHBlYXJz
IHRvIGJlIGNhdXNlZCBieSB1bHBpX3JlYWRfaWQoKSBtYXNraW5nIHRoZSB0aW1lb3V0IG9uIHRo
ZSBmaXJzdA0KPiA+ID4gdGVzdCB3cml0ZS4gSW4gdGhlIHBhc3QgZHdjMyBwcm9iZSBjb250aW51
ZWQgYnkgY2FsbGluZyBkd2MzX2NvcmVfc29mdF9yZXNldCgpDQo+ID4gPiBmb2xsb3dlZCBieSBk
d2MzX2dldF9leHRjb24oKSB3aGljaCBoYXBwZW5kIHRvIHJldHVybiAtRVBST0JFX0RFRkVSLg0K
PiA+ID4gT24gZGVmZXJyZWQgcHJvYmUgdWxwaV9yZWFkX2lkKCkgZmluYWxseSBzdWNjZWVkZWQu
DQo+ID4gPiANCj4gPiA+IEFzIHdlIG5vdyBjaGFuZ2VkIHVscGlfcmVhZF9pZCgpIHRvIHJldHVy
biAtRVRJTUVET1VUIGluIHRoaXMgY2FzZSwgd2UNCj4gPiA+IG5lZWQgdG8gaGFuZGxlIHRoZSBl
cnJvciBieSBjYWxsaW5nIGR3YzNfY29yZV9zb2Z0X3Jlc2V0KCkgYW5kIHJlcXVlc3QNCj4gPiA+
IC1FUFJPQkVfREVGRVIuIE9uIGRlZmVycmVkIHByb2JlIHVscGlfcmVhZF9pZCgpIGlzIHJldHJp
ZWQgYW5kIHN1Y2NlZWRzLg0KPiA+ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBGZXJyeSBUb3Ro
IDxmdG90aEBleGFsb25kZWxmdC5ubD4NCj4gPiA+IC0tLQ0KPiA+ID4gICBkcml2ZXJzL3VzYi9k
d2MzL2NvcmUuYyB8IDcgKysrKysrLQ0KPiA+ID4gICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRp
b25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L3VzYi9kd2MzL2NvcmUuYyBiL2RyaXZlcnMvdXNiL2R3YzMvY29yZS5jDQo+ID4gPiBpbmRleCA2
NDhmMWM1NzAwMjEuLjI3NzlmMTdiZmZhZiAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvdXNi
L2R3YzMvY29yZS5jDQo+ID4gPiArKysgYi9kcml2ZXJzL3VzYi9kd2MzL2NvcmUuYw0KPiA+ID4g
QEAgLTExMDYsOCArMTEwNiwxMyBAQCBzdGF0aWMgaW50IGR3YzNfY29yZV9pbml0KHN0cnVjdCBk
d2MzICpkd2MpDQo+ID4gPiAgIAlpZiAoIWR3Yy0+dWxwaV9yZWFkeSkgew0KPiA+ID4gICAJCXJl
dCA9IGR3YzNfY29yZV91bHBpX2luaXQoZHdjKTsNCj4gPiA+IC0JCWlmIChyZXQpDQo+ID4gPiAr
CQlpZiAocmV0KSB7DQo+ID4gPiArCQkJaWYgKHJldCA9PSAtRVRJTUVET1VUKSB7DQo+ID4gPiAr
CQkJCWR3YzNfY29yZV9zb2Z0X3Jlc2V0KGR3Yyk7DQo+ID4gSSdtIG5vdCBzdXJlIGlmIHlvdSBz
YXcgbXkgcHJldmlvdXMgcmVzcG9uc2UuIEkgd2FudGVkIHRvIGNoZWNrIHRvIHNlZQ0KPiA+IGlm
IHdlIG5lZWQgdG8gZG8gc29mdC1yZXNldCBvbmNlIGJlZm9yZSB1bHBpIGluaXQgYXMgcGFydCBv
ZiBpdHMNCj4gPiBpbml0aWFsaXphdGlvbi4NCj4gSSBtaXNzZWQgaXQgYnV0IGZvdW5kIGl0IG5v
dy4gSSB3aWxsIHRyeSB5b3VyIHN1Z2dlc3Rpb24gYW5kIGFuc3dlci4NCg0KSSB0aGluayBpdCBt
YXkgbm90IGJlIG5lZWRlZCBub3cgZnJvbSB5b3VyIGV4cGVyaW1lbnRzIG5vdGVkIGJlbG93Lg0K
DQo+ID4gSSdtIGp1c3QgY3VyaW91cyB3aHkgQW5kcmV5IFNtaXJub3YgdGVzdCBkb2Vzbid0IHJl
cXVpcmUgdGhpcyBjaGFuZ2UuIElmDQo+ID4gaXQncyBhIHF1aXJrIGZvciB0aGlzIHNwZWNpZmlj
IGNvbmZpZ3VyYXRpb24sIHRoZW4gdGhlIGNoYW5nZSBoZXJlIGlzDQo+ID4gZmluZS4gSWYgaXQn
cyByZXF1aXJlZCBmb3IgYWxsIFVMUEkgc2V0dXAsIHRoZW4gd2UgY2FuIHVuY29uZGl0aW9uYWxs
eQ0KPiA+IGRvIHRoYXQgZm9yIGFsbCBVTFBJIHNldHVwIGR1cmluZyBpbml0aWFsaXphdGlvbi4N
Cj4gDQo+IFllcyBtZSB0b28uIEkgY2FuIHJlcHJvZHVjZSB0aGF0IHdoZW4gSSBidWlsZCBrZXJu
ZWwgYW5kIHJvb3RmcyB3aXRoDQo+IGJ1aWxkcm9vdCB0aGVyZSBpcyBubyBpc3N1ZS4gQnV0IGFz
IHNvb24gYXMgSSBhZGQgZnRyYWNlIC8gYm9vdGNvbmZpZyB0aGUNCj4gaXNzdWUgYXBwZWFycyBh
bmQgdGhlbiBJIGNhbid0IGFuYWx5emUgdGhlIGZsb3cuIEl0J3Mgc2VlbXMgc29tZSBraW5kIG9m
DQo+IHRpbWluZyAvIHJhY2UuDQoNCkkgdGhpbmsgdGhpcyBpcyB2ZXJ5IHVzZWZ1bCBpbmZvIHRo
YXQgc2hvdWxkIGdvIGludG8gdGhlIGNvbW1pdCBtZXNzYWdlLg0KDQo+IA0KPiBIb3dldmVyLCBJ
IGhhdmUgdHJpZWQgZGVmZXJyaW5nIHdpdGhvdXQgZHdjM19jb3JlX3NvZnRfcmVzZXQoKSAodG8g
dmVyaWZ5IGlmDQo+IGl0IGlzIGp1c3QgYSBtYXR0ZXIgb2YgdGltZSkgYW5kIHRoYXQgZG9lc24n
dCB3b3JrLiBkd2MzIGlzIGRlZmVycmVkIGFib3V0DQo+IDEweCBhbmQgdGhlbiBnaXZlcyB1cCB3
aXRob3V0IHBoeS4gU28sIGl0J3Mgbm90IGp1c3QgdGhlIHRpbWUgYW5kIG5vdCBqdXN0IGENCj4g
bWF0dGVyIG9mIHJldHJ5aW5nIHRoZSB0ZXN0IHdyaXRlLg0KDQpFdmVuIHRob3VnaCB3ZSBjYW4n
dCByb290IGNhdXNlIHRoZSBwcm9ibGVtLCB0aGlzIGZpeCBzaG91bGQgYmUgZmluZS4NCg0KPiAN
Cj4gPiA+ICsJCQkJcmV0ID0gLUVQUk9CRV9ERUZFUjsNCj4gPiA+ICsJCQl9DQo+ID4gPiAgIAkJ
CWdvdG8gZXJyMDsNCj4gPiA+ICsJCX0NCj4gPiA+ICAgCQlkd2MtPnVscGlfcmVhZHkgPSB0cnVl
Ow0KPiA+ID4gICAJfQ0KPiA+ID4gLS0gDQo+ID4gPiAyLjM3LjINCj4gPiA+IA0KDQpUaGFua3Ms
DQpUaGluaA==
