Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160DE6888AC
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 22:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBBVBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 16:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbjBBVBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 16:01:11 -0500
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B789081B3F;
        Thu,  2 Feb 2023 13:01:06 -0800 (PST)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312IqwYG028150;
        Thu, 2 Feb 2023 13:01:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=DmzfWIwvPTm6hy/p64vyxei43nerofNpSQU1w3YpJhA=;
 b=sNHCQrVwADSdo0tQpAtF45hmNBn2IUzJSZWyNQ8tJVpzyMmCWqWwLkY9qLVIKD5q009g
 +GeXa8VUNmLQhd4KehBk/g8/b8Bw4JK4postwPGbO6Fxa8xbjRhXUzwF/4CovwIVum8q
 XjvD/Sy5ng/KLc1DOD/U1soxgrl+YMSspGc+AdQUPv4dKsNYVPJWhOBZ156mYRUo18pR
 DPo7RXQQNBK7m49RhPovy5TgD/sKqZ/w8BBIvCKJDVnUBNVwm3Bj4txhg59POECZ0uxC
 yuo8aNNDxIoLYp8VjcWuOTQcxMCpDBZD6uhlwbDdASAHhE3CawENqjrFQXgaYALfCiMC Vw== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3nfq4nran9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 13:01:02 -0800
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 10FDA400AF;
        Thu,  2 Feb 2023 21:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1675371662; bh=DmzfWIwvPTm6hy/p64vyxei43nerofNpSQU1w3YpJhA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=LhYm5MvfeefETtpLnklNv7OHTEPeMSYjdZgzmZAMzFnUtWSaxXtFM4PXpA7pavPGj
         Q7wZQR/Aqf4AzVNT0OKPDvRL5PLVRUj3ngFb4jXoIn4lLMbhy0emwHdGwsj/VovyXu
         nD5PfLKifOP5rzjFCtHZ3ieMkRpf3hsbViNCj3kKueiXPWf5gcqrNkgLQ0B9oqUptQ
         CJgSdt4+H3vxh1Y3pObKnL90RdiJZOvkFd/ZLU3pB0kBlfdn7DkRSkBpWEqKq935RP
         Zr+SEcYJM2sqMVivc9PA1/caob8rQDX9kk0aEinGx/dWLbyYNouKWAUl5lEFuNUEQJ
         8LCMoJCrFGBcA==
Received: from o365relay-in.synopsys.com (us03-o365relay7.synopsys.com [10.4.161.143])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id BF0CFA0080;
        Thu,  2 Feb 2023 21:01:01 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id E144DA0093;
        Thu,  2 Feb 2023 21:01:00 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="chI7v8mc";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YeQl1QNfu5xZGXEalkJhW52gpAk5Ubr+P/aficF8fUy1ufAzh/r7NHKbSgbyjDkiSWUUUqqQiSPquUygeWhYlsHyDaX21YrJflcSlyUH/Ye/UtWO7RChOY9klPX6y1uKAej7hW8dbDo75/p/mQ9RRq6B4tWTyJ9SHVbB3EgcL0OlP6Q/2ymg47Q/byrRVAk1o2OTEIuK+pGTs635pVRlk59ciKd8RdLUy7lCX9m04s824DOgxrfWAqVBLvEnk0+XYWT+IRRzODaj7DFlYsZyvsAeN59zwO+459UONLETUza9hLd5esoxwdfOVKU7GQo22nO+oqnrY1WBAgTG3AACDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmzfWIwvPTm6hy/p64vyxei43nerofNpSQU1w3YpJhA=;
 b=nmy6qDq4rQHCXcLoUIi+O11QXgBu7g2KX30QiEQBdLIPmk2jgQf+xEkcTJ88K0Bmk3zSWjM7pjoaOx3SqgXUWvxY8+Jtacuf4uuhqBgrpgrssSZQqvE0fJpnIR52GBQ3devzC6hmp9eJu+vYPt0Kobfq+RnF1+DhE0520bvtW2pI6bqYV0n/z1+Zce86aH1lnUdTs852Wir/IhHtX2Wx7sZy24EobnbLNDfVQQRR3ItmwgBRxgs8IKaTbHeJSrd5Kd8jADqnYTe6h/teQk05q83ARwlmo+azNLkjv0zCK8MYkM2T+cUuzLEocIu6jDCqf725QwmRnXwv+eyLsbOSqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmzfWIwvPTm6hy/p64vyxei43nerofNpSQU1w3YpJhA=;
 b=chI7v8mc5PFn+/KivHA6sdKqyDt1Awnbc5oZ8iwywXodz4HXU15Xk6YBL+sdiTDwy6vHI4FQZ5aC2V5HtjDUse2fy6v/T4YTJdFAUg34Yg0asU6UCaJ3uAT1OTp1f8aSXcvmGCJPp2ao4EfGnERITNnzMKDYDx/tkpF1DjdnUaU=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by PH7PR12MB7235.namprd12.prod.outlook.com (2603:10b6:510:206::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 21:00:57 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::6f3c:bd8e:8461:c28c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::6f3c:bd8e:8461:c28c%7]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 21:00:57 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Jack Pham <quic_jackp@quicinc.com>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Wesley Cheng <quic_wcheng@quicinc.com>
Subject: Re: [PATCH] usb: dwc3: update link state when process wakeup
 interrupt
Thread-Topic: [PATCH] usb: dwc3: update link state when process wakeup
 interrupt
Thread-Index: AQHZNetg1e8bWR5O+UmEKJODDDA7p666dI4AgAC0WYCAAO/lAIAACEoAgAAF7wA=
Date:   Thu, 2 Feb 2023 21:00:57 +0000
Message-ID: <20230202210050.i36mnry34nditath@synopsys.com>
References: <1675221286-23833-1-git-send-email-quic_linyyuan@quicinc.com>
 <20230201190550.jozzrvwdi5lcwtbo@synopsys.com>
 <197a1446-9382-3d83-d26e-694e4d707679@quicinc.com>
 <20230202200956.kpyp6cq67anpxcie@synopsys.com>
 <20230202203936.GA4054742@hu-jackp-lv.qualcomm.com>
In-Reply-To: <20230202203936.GA4054742@hu-jackp-lv.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|PH7PR12MB7235:EE_
x-ms-office365-filtering-correlation-id: cfc51a1f-0ac8-486b-b57b-08db0560949d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ITZURXbigX+IOFGkBO/3ZPq/eR+iuo2O4tIsGdJWZQ+XLC/Se8ph1tgxcIwXPnD1a9t6JArVHRGmuLvt1OF+KqTHK9Up7fDS2UEICgMD0nRTrtnqzPwjO8+kl6B2Fty3ixthZReFSaldo9JPgnrKa8lTfqaalFTlOncBJCxhSlsfFzuH+CAwhC9QCVJ3fRgrQWIjMnEpZcXko4Kdah6CjWEfLeNdk44H3+0TVYHJkCEHvDGZ4ONSbI0V5rSU8cUinr1jHL1cFgPnXuyHeuBvYLFKREDp856gA4l+epGPkdmKF4RLWUTmZHK1d/pAKcHi/3KPwf0G5DmfIo1nohtOAbMjZwhe67ia60834DOL9RaWJ7vKezzoldsUtrV8SifCQ/XFwv/z2fDedTHWZ4tU2ZZDRCYJy6MKCPU3tIZFUZyRua0sv258MXHiw528KT8g7EbnuWlS+J5jbDXozQwAm3qlDUA3G2GDJ1RXGJUBqZwqR8ZQon3W3JiC5YEu9inYDqnX1QdLast/lNz9cmXqPAaMOc5aDXStqueMp8C/Wj3Dwe6cW56EwujRoheMmLgUq0AOC+haCy9pzmCQCjEYByp1Zi9GIzAymKLXbzr4VoK3m0wJktDMVRqMtJ7AjoKMu6M2l1np283/XSRAmyq7T6Z5TQKO1S9ANhc/446fZNksMTXx5Aa+nkIxIDS6hvpCx0QvUwCCn2dMee1+tY6Mgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(136003)(346002)(39860400002)(396003)(451199018)(8936002)(2616005)(54906003)(5660300002)(71200400001)(4326008)(316002)(2906002)(8676002)(41300700001)(6486002)(66556008)(6916009)(66476007)(64756008)(6512007)(26005)(478600001)(66946007)(1076003)(6506007)(186003)(53546011)(83380400001)(66446008)(38100700002)(122000001)(38070700005)(76116006)(15650500001)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SittZ3d6OUxibXEwZGpqb0Q5OE5OZFlSdFBvaldESC9JRkhEOWhpaExEdnQ5?=
 =?utf-8?B?ZkZISWRYU290TncxRmtZNFdrYWhtQWt5ZWd2dGFsOVNtdi95TytLR1RTSzJk?=
 =?utf-8?B?b0Y2S0NncGZvaFVCeWVaOGxUbTdPc0lHRy9qOXRscGY5V3h5eW9yUUxMZFZl?=
 =?utf-8?B?V24yUjdYMWh0aU1yaXI4b0drOUc0elcvY1YvejUzQXU1TFk3aXJlOGZPM2dE?=
 =?utf-8?B?MW1wejc2bmdDazNLZlEwZUlBRVpXV25ZUngxQ2FlMkRsSHRwVkNFME5ObTh2?=
 =?utf-8?B?bUdtOW1nb0drOXJ1dWNMb3UzR1QxZWZPamt6MHZqbmwyNmFoK2RZaVNFcFYr?=
 =?utf-8?B?dFlKU1lmWmdqVEE2ckxJc1hKUlRnSktEcHZGVFU1V1BJNUk0ZjRpNkJHd05z?=
 =?utf-8?B?clNXVWF6YVlxdTB4NTEzbGZxaVk1V3laVC9ycGs1Q1ErTnFubklBYUVXV1Rr?=
 =?utf-8?B?SkVBYzdBU0tFZHowRk9YUUExdXBUay9NVkJQYWFxVW1hWUFiS2VQK09YdTd3?=
 =?utf-8?B?MTVVZWQ5NWlLWjlvK0tpaUsxWGJ5NUdFU0FYWW80RlBUZ25jZTJHZXJnSmN6?=
 =?utf-8?B?NnEvQnRNcnJkUWtieU5IbUJ3YThqQWtld2JRbFUyYnpmMWtGYVZQTmJVY0ll?=
 =?utf-8?B?UTZqQTB0a3JSQk9pcGJkUWxPZlR2aTJ0MUJ6RCs1dEJBa0ZYUWYveThIV01X?=
 =?utf-8?B?YmV4Z2RESWF1UndjK2FaNFpMODNlRTQ2K09VZk85c01ZSnJzM1FLR0FPeXY1?=
 =?utf-8?B?WFloSzJVK1lsWnRlbXNWSU1sU1hudFVMcGp1bHZ6SU9ScVduNy8wdVdtajFz?=
 =?utf-8?B?Sk1UMXdnTk0rZStUZVd3dDhRNGNwb0d1WllnVG9PeCtjRitCQkowamNOR1Ay?=
 =?utf-8?B?cWRWaXh2WS80eThqeFEwbzd2bEpEd2F5cGFwSWVoenJaR0dPZGdLZHpxWlNQ?=
 =?utf-8?B?MGZ0MUg4TW9ZVnkwSnpyazA0S2FwWTRhcDBjSkIySEVTUnoxTmpxeSs2Ri9r?=
 =?utf-8?B?cEswVzM0WG9SbDl2cDIwbWZFQ0x5TzZERnM4RDA0U2ZYZFVzdVhFOGxDUFBo?=
 =?utf-8?B?WWtuSUh6bEFTVmx2Zmx4TEpwTlplZTVHSnBQOEhsSmNYa2tQdjByQWtHWVhH?=
 =?utf-8?B?Ykc3WiszQndqa3RmcHlpLzVjUTJaVlNOVExZdTV5bzl0MGJwMXNNOVFnN2tE?=
 =?utf-8?B?azJMa3kvcUlGMjZXMkpPWGFqS1NRUGFPQlI0a3FyeWI2M3lJNG1DdWNqcnlC?=
 =?utf-8?B?L3YrZitQcUdwaE5hMUhIM1B2WE1aTCtzQVpZaU1xaGtYVWFGdUplUUN1MlhL?=
 =?utf-8?B?Zk1PVDZqbDlUam9OMWkxNlVoT0VYUFZlbDRxZnBPTnFuTWc0cCtnQ05NVG9M?=
 =?utf-8?B?Wmw5ZG9tb0s1cTFMcys5bUo0TEdqa3hTeDRlR3hhR1c0dGpnSUo5NnZCOU1a?=
 =?utf-8?B?bHdBRW9jMGhDRmhwcS8wSmkzUitnRjBEV0w3b1Fld3ZIdVM3b09ZbkVwYVYy?=
 =?utf-8?B?VDBkTDdwNDBtK0dCK1NneWUraHkxOWNUL2pjc3Zwb1p1K20raDRuRVRKeFFM?=
 =?utf-8?B?TFkxT0RvT1lJVHVETGRqNDg3OWJQc1g5RXdBSWNFc0ZMZVUxQzkxMDZrYk1w?=
 =?utf-8?B?WUJEOXdFcEUybTBlWGNaczI2cUY2NkR4bXZ6QzQxeWV5bEhGSElPMno2Zzkz?=
 =?utf-8?B?aE5UYkpDcEpNcC9uSnRQUGlEakI4a2R1d0oxQXlqYXJxMTFiblA2RE90ekdH?=
 =?utf-8?B?MHRaOXhBMExWZ3F2RVBiVDMwUkE1SkU0WUExLytDRW8vVTBSSEt6czFKSWNT?=
 =?utf-8?B?eWYxOU1EMVFYU1B4S2ZzZ2tTUXlOVnJ4emhLRjY4OGpnNTVTdmljVTJ4S0Ji?=
 =?utf-8?B?TDVZaVJkY2RlRWdSb2dYbkcwQ2Y4U1dEaHA4SG5PaGJsUUtNam5pdk85dHkx?=
 =?utf-8?B?Wmo2UWlUT0RUdVV5K0dSYmF4MmpXU1pkcGZ5Q0l1c09YSS9NOGlIUmdIYlJ1?=
 =?utf-8?B?WFhxRlVRaGRBcm9MNWdzUS9udkdBNzZjZjBPQzZidFZWOU1CS0xDTWJtbUNH?=
 =?utf-8?B?c3N0VzRiL3I2WmxENkJyVFFZS2pHemZncHoxZTVmcWdiUFV0Vm1KVndzOFlU?=
 =?utf-8?B?VlBKUjVvSWpjUXY1aTFNMzFVWjhQVWVwa0NsN1ZseXpRcFV1azBvVWVaUlpE?=
 =?utf-8?B?VkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B3E5D22A7F5F34AB9EFC5098F884D70@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lFxPEHzRuZ7cyt6KOPLMcyqY2O/0aSkU/2jDO9ZvOXaviEBc416fwli1iwjkYdRic3ybH0rDN1mgb63kQMnfO/OaabyNqgmB8sM81x/aZFt2Y8JyDKkUvjGBZQP7TKoD5HSf9gCsJN9p5tiL9pPMoMmW1QSba7HVAzhi7RrGS+MvaWWeZkY2/cLgVrqh1dU4RN3195Jzco6qZe9d7HdfV9LAD7A3pbKePSir/Km8jReEGQ5NmySzATI8oKrk6cJpHC2LNO0CDENn/uH0Z1Zr2BYkiBoXfxyazLgPIvw0tH+s/OInCWgbTnPt1szn76TQxOUL09wgUC3jUTFNwYXSGTgIvYI6g6KWFLihzvSIDmwU4+rAtTuyvwXszP8HF8g3KWpkjAUkiZxjdaCg+v/lvGqynIvi65HkVIdmc8jodZSY4t12ggTrQAEYYH+lifBzqf+V6UYQwtpzSywS65Uz0QHN7nLpfmBuHgvlER1XkO7GaPmpmfqvb637V+JbkRqccAGG1PIRdPatNXDTgPHg34SkFCcFDI+no4oUEnzCrJlpuCQwer8e/IVrxoeLL9wRpVCkTp2VQpu+AMVC6cYiLJVGoFY64y8gepjmIDJQtKn2UWtDI1O8eX/Ec4ci3F8gvMhpL1VhbgEEUY3lU0E4S7VhElpHP/eC4QTI6a9IxG4LTaxKotVpnbXEO6rJmS4+j9NEoD3v8+jLc/7E2wz9JXG/S8twPUVc5vqYACYahEuEvn1FcQDC/rZGTS8W/IgZzlAHCv3YKdmHPpOVVxmoKmIFDOoAwBBQ/ucYYaTKsW+4NGKHub9UXgrNMjPyyJ0ogrpUKe+1giitGdj+zTqQ0/0ovDs9rjBatyFFGMU6lNdZABcWtW6sIRGfZnsxHWSr
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfc51a1f-0ac8-486b-b57b-08db0560949d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 21:00:57.0951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g9oxgkfZ028a0fgYr+1DipVODVNMcvMT/cqDgSFBqBYo3d55g8HBHapbM8mdpzo/oJv3r9gsRKQvR5mBQqN+Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7235
X-Proofpoint-GUID: VitcGYYH7yAxhKgjbkKYFkFuLXk288xB
X-Proofpoint-ORIG-GUID: VitcGYYH7yAxhKgjbkKYFkFuLXk288xB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_14,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 impostorscore=0 mlxlogscore=366 mlxscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302020185
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCBGZWIgMDIsIDIwMjMsIEphY2sgUGhhbSB3cm90ZToNCj4gT24gVGh1LCBGZWIgMDIs
IDIwMjMgYXQgMDg6MTA6MDFQTSArMDAwMCwgVGhpbmggTmd1eWVuIHdyb3RlOg0KPiA+IE9uIFRo
dSwgRmViIDAyLCAyMDIzLCBMaW55dSBZdWFuIHdyb3RlOg0KPiA+ID4gDQo+ID4gPiBPbiAyLzIv
MjAyMyAzOjA1IEFNLCBUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+ID4gPiA+IE9uIFdlZCwgRmViIDAx
LCAyMDIzLCBMaW55dSBZdWFuIHdyb3RlOg0KPiA+ID4gPiA+IENvbnNpZGVyIHRoZXJlIGlzIGlu
dGVycnB0IHNlcXVlbmNlcyBhcyBzdXNwZW5kIChVMykgLT4gd2FrZXVwIChVMCkgLT4NCj4gPiA+
ID4gaW50ZXJydXB0Pw0KPiA+ID4gDQo+ID4gPiANCj4gPiA+IHRoYW5rcywgd2lsbCBjaGFuZ2Ug
bmV4dCB2ZXJzaW9uLg0KPiA+ID4gDQo+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+ID4gc3VzcGVu
ZCAoVTMpLCBhcyB0aGVyZSBpcyBubyB1cGRhdGUgdG8gbGluayBzdGF0ZSBpbiB3YWtldXAgaW50
ZXJydXB0LA0KPiA+ID4gPiBJbnN0ZWFkIG9mICJubyB1cGRhdGUiLCBjYW4geW91IG5vdGUgaW4g
dGhlIGNvbW1pdCB0aGF0IHRoZSBsaW5rIHN0YXRlDQo+ID4gPiA+IGNoYW5nZSBldmVudCBpcyBu
b3QgZW5hYmxlZCBmb3IgbW9zdCBkZXZpY2VzLCBzbyB0aGUgZHJpdmVyIGRvZXNuJ3QNCj4gPiA+
ID4gdXBkYXRlIGl0cyBsaW5rX3N0YXRlLg0KPiA+ID4gDQo+ID4gPiANCj4gPiA+IHRoYW5rcywg
d2lsbCBjaGFuZ2UgbmV4dCB2ZXJzaW9uLg0KPiA+ID4gDQo+ID4gPiANCj4gPiA+ID4gDQo+ID4g
PiA+ID4gdGhlIHNlY29uZCBzdXNwZW5kIGludGVycnVwdCB3aWxsIG5vdCByZXBvcnQgdG8gdXBw
ZXIgbGF5ZXIuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gRml4IGl0IGJ5IHVwZGF0ZSBsaW5rIHN0
YXRlIGluIHdha2V1cCBpbnRlcnJ1cHQgaGFuZGxlci4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBD
Yzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gPiBDYW4geW91IGFkZCBmaXggdGFnPw0K
PiA+ID4gDQo+ID4gPiANCj4gPiA+IHNlZW0gdGhpcyBjaGFuZ2UgY2FuIGFwcGx5IHRvIGFsbCBj
dXJyZW50IHN0YWJsZSBrZXJuZWwuDQo+ID4gDQo+ID4gRGlkIHdlIGhhdmUgaGFuZGxpbmcgb2Yg
c3VzcGVuZC9yZXN1bWUgc2luY2UgdGhlIGJlZ2lubmluZz8gSWYgd2UgZGlkLA0KPiA+IHBsZWFz
ZSBhZGQgYSBmaXggdGFnIHRvIHRoZSBjb21taXQgd2hlbiB0aGUgZHJpdmVyIGZpcnN0IGFkZGVk
Lg0KPiA+IA0KPiA+IFRoYXQgaGVscHMgdG8ga25vdyB0aGF0IHRoaXMgaXMgYSBmaXggcGF0Y2gu
DQo+IA0KPiBTdXNwZW5kIHdhcyBhZGRlZCB3aXRoIG15IGNoYW5nZTogZDFkOTBkZDI3MjU0ICgi
dXNiOiBkd2MzOiBnYWRnZXQ6IEVuYWJsZSBzdXNwZW5kDQo+IGV2ZW50cyIpLCBzbyBhcmd1YWJs
eSB0aGUgbGlua19zdGF0ZSBtaXNtYXRjaCBvZiAkU1VCSkVDVCB3b3VsZG4ndCBoYXZlIG9jY3Vy
cmVkDQo+IHByaW9yIHRvIHRoYXQgaWYgc3VzcGVuZF9pbnRlcnJ1cHQoKSBuZXZlciBnb3QgY2Fs
bGVkIHJpZ2h0PyA7KQ0KPiANCj4gQnV0IHN0cmljdGx5IHNwZWFraW5nLCB3YWtldXBfaW50ZXJy
dXB0KCkgd2FzIGludHJvZHVjZWQgYWxsIHRoZSB3YXkgYmFjaw0KPiBpbiB0aGUgZmlyc3QgY29t
bWl0IDcyMjQ2ZGE0MGYzNyAoInVzYjogSW50cm9kdWNlIERlc2lnbldhcmUgVVNCMyBEUkQgRHJp
dmVyIikNCj4gYW5kIGhhZCBub3QgYmVlbiBjaGFuZ2VkIHNpbmNlLg0KPiANCj4gQW55IHByZWZl
cmVuY2Ugd2hpY2ggdGFnIHRvIGNob29zZSBmb3IgRml4ZXM/DQo+IA0KDQpQbGVhc2UgcGljayBo
b3cgZmFyIGJhY2sgaXQgY2FuIGdvIHdoaWxlIGl0IHN0aWxsIG1ha2VzIHNlbnNlLiBUaGlzDQpo
ZWxwcyB0aG9zZSB3aG8gd2FudCB0byBiYWNrcG9ydCBpdC4NCg0KVGhhbmtzLA0KVGhpbmg=
