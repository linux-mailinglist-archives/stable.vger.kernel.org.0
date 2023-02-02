Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676F8688B34
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 00:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbjBBX7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 18:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbjBBX7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 18:59:00 -0500
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE257B415;
        Thu,  2 Feb 2023 15:58:59 -0800 (PST)
Received: from pps.filterd (m0098572.ppops.net [127.0.0.1])
        by mx0b-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312GaIFI016878;
        Thu, 2 Feb 2023 15:58:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=CsRqUhU0ZcYUKK1FAR2Nq0IAIJl47TQFWEP9dGm2wPo=;
 b=T+795JFbQiyJvt/qFf/tJiPVdroj3fGDs5KmoIN6C4yw4fM5X9x4s1R7nOiDf/yPtEul
 WTToWTP/Ucn+HV6yOyWhW6UeZX9YimGJ6eHBIOMcOtVei6T9y03V4vKMcW5YUf4mOy6u
 nx5H49iqL+qDvnyKS0zSQ8HI9tFx8Gap9qYa3robl9l+zMCASFP03BWYE7fYKtKLKzzb
 p0hl+ekN4NP4femCmP0IqYYqYAEkvuQimXloEHx1Xe1aUt3kNbOjsG2Yk8DGMvjNkNwJ
 tu21GI5K7HbmEjZ8JrYGebaaNW8RVpZ/BnyyCgqO7oPRpePTdlceQgoM3SLvRqfQcM2A NQ== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0b-00230701.pphosted.com (PPS) with ESMTPS id 3nfqbpje5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 15:58:55 -0800
Received: from mailhost.synopsys.com (badc-mailhost4.synopsys.com [10.192.0.82])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7C761400CE;
        Thu,  2 Feb 2023 23:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1675382334; bh=CsRqUhU0ZcYUKK1FAR2Nq0IAIJl47TQFWEP9dGm2wPo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Vxo29cdvYTeQOI8OpJ53/8T68GKiUwGd0V8yXLlLzam/ehxid1SzPn0mmxmLS9SWT
         uy7G7ex/JlcosRQgrCtINCmy1S12ENbIrG3eKndBpL5s5i0UD5u4DR7W0lBap9JIrZ
         hx5WuTf0fUL6QdxSSlntiC5cl1ULSHevy3u+3sC8Iv2Iz5VDLRxWGPSFSTFAGSlUM8
         mZJwQPWCf33jmV7a2vdDFE84Lbzm/tzlOFP5V9CObp+/Kc/bTXhFvAICDGkgkkys6p
         W1k8VnkYD0du5cGugTn7MoqTMYO5yX1X0nNohTtN6JDdvSnIrIAfhYvHTOs+Rf7CMo
         ruvaIzJ96U7QQ==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 19504A0060;
        Thu,  2 Feb 2023 23:58:53 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 205144011D;
        Thu,  2 Feb 2023 23:58:53 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="UGzKmaeq";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KlhxUqLOuvaLvVTdIoffT39LMTPwk3vd7drT5NyoADnXg2QMik0SevKvCNtBsUwHDF71skytEpNK32PuY5gEMcD5ik0xohoiiPAqx8iYr3ScO9V9blwOtg5R2RoR7dCsU0kuQVx6lGWFelSTZJT02M/f1L1Ct3L41/yFCH/hafXQWNzJchVQanhm8DoWFkH6DD+DeRIVbJ7ekn+H/F3R3N8YNiGOGrtAWqdQPdP7P1acnnliEMt8kzKHnZQMVBJ9frp1vMkz6VITOEo2dHNh7aJXe9X2V/nXf423bSLyWXr/T6Ebny1lfWmPUNlMuJnq5f/J1XHkJS3I9lnrYQXhEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CsRqUhU0ZcYUKK1FAR2Nq0IAIJl47TQFWEP9dGm2wPo=;
 b=ZQphPGSqucwGlP0gITT5xs3WQgGYHUfHuZ+GdkhG0r/jaHiHxvxsA1NeuZJ4nsdBhVcbMzvRSTDEJ6UJbxPd5JhUwFHsaR7PfoG8eU4WeiHZxwibnGVQA7R40xjLFMw5pKoTt/XoA2MOZzm0/iEsEIRMitF06BO1iB1FhJkfBTSLwt+JYW///PSi1AtnROc6WCemOS/yl51xQx9zfMlNws08FRa0yqj8K9P+qPJy1xABrTMEw+4VdDvpX9e8naguyDTnBXIdzRap1diNEso+Qn7IXIqSUJdotXtgiXwPUoMzeFvkFmacLBK9jXKc513RRs5HK6X/qmyZ5vi41Y+PZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CsRqUhU0ZcYUKK1FAR2Nq0IAIJl47TQFWEP9dGm2wPo=;
 b=UGzKmaeq6WemmguHWSIo3dhNJ3lO95bDQaWNk6oWpPN8sDv8+iIzeHGiN6sC9TBua4C7sIinYpcyO/ZWd8oLlMU+iycovBDokLp/94DDgI4fZwfmJIRfcN2m5xhqrWYinqdjGKhGKepEm5d7hqm77/DI3D4hu4exMqI8tFFEj7Y=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BN9PR12MB5289.namprd12.prod.outlook.com (2603:10b6:408:102::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 23:58:50 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::6f3c:bd8e:8461:c28c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::6f3c:bd8e:8461:c28c%7]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 23:58:50 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Linyu Yuan <quic_linyyuan@quicinc.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jack Pham <quic_jackp@quicinc.com>,
        Wesley Cheng <quic_wcheng@quicinc.com>,
        Elson Roy Serrao <quic_eserrao@quicinc.com>
Subject: Re: [PATCH] usb: dwc3: update link state when process wakeup
 interrupt
Thread-Topic: [PATCH] usb: dwc3: update link state when process wakeup
 interrupt
Thread-Index: AQHZNetg1e8bWR5O+UmEKJODDDA7p666dI4AgAC0WYCAADgqAIAAv8OAgAA33gA=
Date:   Thu, 2 Feb 2023 23:58:49 +0000
Message-ID: <20230202235838.5d3a5lgdspahk6od@synopsys.com>
References: <1675221286-23833-1-git-send-email-quic_linyyuan@quicinc.com>
 <20230201190550.jozzrvwdi5lcwtbo@synopsys.com>
 <197a1446-9382-3d83-d26e-694e4d707679@quicinc.com>
 <d6e66c50-421d-f57e-fae3-1a4e14dce780@quicinc.com>
 <20230202203841.5vxxtejol3zyjjef@synopsys.com>
In-Reply-To: <20230202203841.5vxxtejol3zyjjef@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|BN9PR12MB5289:EE_
x-ms-office365-filtering-correlation-id: 007a69cd-62fc-4ea8-1f3d-08db05796e0e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TH2qiILUIHTJebQApxxq5YaXiw0FOAxci6cqMADht1cwjl41mm+Z7TBJ884wSdEHMjqab/8cfm90JxRcbmc3/IJzctXqD3PpUbIYo8Hu/ttiKn1+Gp5iMEfPTz+KeCR4e3qRvAZINdImKtZuBhgHERZbtRW8q/NVoQyG/qtutoNmI8Wa2bzHRAEgxjEIzT9PwC8wDQ5nqrjvkHK7yULd1ifpjfwgUsOhgxkEBKgD+HXlCueGaZtUM9eblz5VvH6/Xv9lyNuE7YoDYI7DDwI0n+fKX/NVj6Wzavjtsd/tC0bkQr5PTqJzWbPkWYZs3/kONIwod61eMy2dmCMcfJClFu6RqslQm81eRXEQ/JNm3iJvbMbAFxVRJExWL+1kOxxmBJb4K/to0lJvyrbbWFnCm2PzFahkZwy6WcByFnpQroHVZLqk98DhCt6Rzd6SisoWutZ+NLpxUHJSbLbUuf7FJr17LX8KyYiTVSKSVdMT2qHUa3prFOmswNV5JhedkfOZQl2QKnv8R11I9TSdjQU5jAB55rSIjuNzhQB2vFJ+c6aCbfkRA4MrbFvdKOVGcZiit+yXsAh4OAFIi4mTlZOj2VWz5tSwakIDHXnnzkTRfN4u3njNARTs6ptSM4+DI8MLFO8VZ1eyQfkahgeFRXwUWTMlXLajXWobpYkbB/WDaCbW1ulUIDG6FAs88s/zw1H3fZKSN56dS+2LRZCpotVvqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199018)(8936002)(2616005)(54906003)(5660300002)(71200400001)(4326008)(316002)(2906002)(8676002)(41300700001)(66556008)(6916009)(64756008)(6512007)(66476007)(6486002)(26005)(66946007)(478600001)(186003)(1076003)(6506007)(83380400001)(66446008)(122000001)(38100700002)(38070700005)(76116006)(15650500001)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NHdlQ2FoM0M3RVhzTnJ6OVJlUTdmTEdITDU4N214RTFQZzBiSXlpVTZhangz?=
 =?utf-8?B?VmF2d2IydW9pa2F6Wi9HdDhWTUFtQmF4U3RxSHRwc2h6clNYb0FwUURPc1M3?=
 =?utf-8?B?NXVkUFRXOENQS2FQZU0vTndnb3NZMHBZUnhUVnNRdThrcXdjdEFjcWNDM0N2?=
 =?utf-8?B?bUx2bW52NCtCbVBwelpHUWYrRHpLMTZDZUtGR3pFR2NVUFdCenhQUnVqSWpX?=
 =?utf-8?B?cmhMalFUNmpVVDdNVHVQYnJublEyNklDbGhOL2dVdmtOc2l0ZklyS1U4YnVU?=
 =?utf-8?B?TUR6ZlJHU2ZVRFhlQjRKTi9kbWdDMlIyQzhteFBVdUQ0VVdUYWEwVHpQSlpa?=
 =?utf-8?B?WDhSMXZmU09KMWpXSS9OaXNXczBmZ2NmcVQwK25tb1ZBWFhNYlMrMW04Mi84?=
 =?utf-8?B?U3NpRVJjRlppT1BjRmJxZmI1b2ZnQTU0SnJZbjRka0hZVGUxOVVtV1pXWnVu?=
 =?utf-8?B?OFg4K1BZeEtkTlRnLzZHeVF2U3U3RWlaU1pwYmJMRUtFTzczMXNHRGlPYS90?=
 =?utf-8?B?c0svaElaVXN1b0tVNER0YjAxKzhPeHJWS0ZYUG80MXdVRFN6eFg2ZHAyL2VF?=
 =?utf-8?B?d1l4UU93QlZNVDdLdmFRWWtQaU81b0RIY1dhSHhCR2kzeW5XditmYzNYdjRn?=
 =?utf-8?B?L0JCeGpMK2pJQkJlZW5QT3JvZGNOUUgwYUFnRTArdDdmSS9kQWgwV3Z2clV0?=
 =?utf-8?B?di9xWTJ0K2lMQ2VRUU1LNVBmclUyMDhDcmRIcitxYTNuREc1Mk85VGRoNVVO?=
 =?utf-8?B?a0lONGJKOHJRVjU1VWgwd1VDSHBFb1VZbnFKaVpjY0VCczErVzZVcmZ0T01T?=
 =?utf-8?B?cjZLZVN1bklFNlZKaUgxcS9PeHZlUXFVWFVVdDVXVUhtZ25mVWxkbUp1ZTcv?=
 =?utf-8?B?RjA0VWpjaGRhNnhHM2VweDFVdy81ZzkzcGVTczdVSEFCK1RLV0tFR2hlYUJj?=
 =?utf-8?B?UTQwWWliWmFsYnhWb1hkL3hPNUhUREJyTW5yN0hzU2dhNDdVNG54eVNUZWt3?=
 =?utf-8?B?WTZ4citHU0VkUFJzcnU1bkZxVGFJNFBrZGJFMjUxT1NmUldQajdvbzJyckl0?=
 =?utf-8?B?YmJmRVZ2V3NXbEw4TFFaVCtxdlQ0eW9wWFgxY3FabTFxQ0U2YW10Y21QeGRC?=
 =?utf-8?B?ZC9kTUxGdUJtcks2R2ljdnRxVUh1b1puTTFZZ1NMYUZaeUlUNlBPeGM5ZVNY?=
 =?utf-8?B?MzZYUDFvTi9PaGlFTEN3SDhPZzRVSUphM3ZqUmdnYVI5dUdYTk95THdzRVZ0?=
 =?utf-8?B?WjluQnp0aHFNWGpENGtOY0tuLzlsUlp2bUg1N2ZhZ1c4YzVJb1FnMUpabCtk?=
 =?utf-8?B?RC9mV3hqaFp6Y2hDbEsxM0t2aFB4bVFqakFpa0hIWXpsV2hScmpJeEExek9B?=
 =?utf-8?B?NE5za2FNQVNRV3VoZlJucFREVVJYT3dmM0RLcnZuZXlXT2NOaUpOSjE1Qmp3?=
 =?utf-8?B?N2JJYVl6NVpVVENwRGZKdU5IQVZ5MVpCS1J6YlY3OG9DWkJYNDFqQ1Y0REtG?=
 =?utf-8?B?TmRYWFZLM1NJWWY0Nlp4MVA0UXdiVWVvMjY5UlVIZU95ZWdZbmRGdEZ6Vldo?=
 =?utf-8?B?cjljOTg0aWVyVWpJQWNIeXEvT09vUklzbTdvS1VUa2I3NE5HV3p3VCtFalhL?=
 =?utf-8?B?UEQ0QXdSck1RSXhwMy9uSWQrcTJtanZ4UG9jMEJDdWRUbWtKQUVFQXZrNmpm?=
 =?utf-8?B?LzFzNmlrSG9DOVpHU0pyRW9sTlNsbTFhQysyY2pwaU9YdFFwNGd4WmR3ekNH?=
 =?utf-8?B?d2JqRXVoY3BJelBLWWxrWGhLUGNJUjBGa1kxT09MbE5CcnJkdDZSZDhZYlBo?=
 =?utf-8?B?eC9rcmNFVTR3b000djBkM2FVOU9IQjU5cytubVMrNVBDcFFZUm1weGdGRFlL?=
 =?utf-8?B?RjVCYmsvVW91TEZncUdUeFN2S1lERHFEQkM5K1VjZlBaam9jbmpIejRLeG00?=
 =?utf-8?B?ZVlxbHgyRzRmRDU2VHVYSHkvQWxEN0JYUFZ1eVhoT3NFVFBnK1U4aU9MNzFY?=
 =?utf-8?B?SjJPdlhpWkF2TmdUQXVybk1UNmJPVS9SVkwwcGhpeHpxSnFVazhLbS9naWNr?=
 =?utf-8?B?N21CekU5bEcrd05yODBYQUZKeVZGNU1kOXZyWEEwd1B1cnVrZFdnKzZOems0?=
 =?utf-8?B?MHRIa3hadTlONWJyb2ZScHhuQzhqRjlZaklCeGFWVHZmQkgwNi9ZOEZjci9Y?=
 =?utf-8?B?T1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1BBA87BC56977848A7936171D389E10C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DHNST78Q/GYsexwytjzTh0/NITlH4gBV6BVOtL8H2HLdrxbyRl7ddZ6K5xoz6jzlf8dthyDHapF8O3kSm2QOmljZC1iAJghPZLFfNXbLsArmK6ZB3oZ7+y/DyeezLSG/AMSY0NwcuNkHdbYyYfMGVaM+M5MBjwRz+ddVIWlLdDW1WynNhiRj2aO9RBImz2Hb4iLu3N6exM+DCMsZpxMQ6OZE9thfDupVeyr3c/xaDN+dBvxCUPl3Sbf93QejLBYPTHDKsDvCtHUUp/h3tBiocZD6AL6ZBZ6mShhGVt0ChG1IggnRp/d3SxfuFy+8sp3Ms/n3e6ZIV2zpYSEM3PyVYzvfPpPujOJZh9MxHlB9UgeDFqMjU311CrNmwVeOwf/cS42Ej2EbUcdiSyhVAP41bmzGaHOOeCeprJsEgxWtPWjvLeKVP+cHuKbuiaGLysooP+w9NDvRja82Q8Amq7/sjIHJ9bH7NF10ltE+SJCYT+kczAJg8wmKRRV91AbPpD4KZlo0Z09/oYd16ERdxRLfmQzdfnajVRwj9HGv6///ylbUXdyIKw/6SHVjDNklfKRTfAZKhYA/qDy+fJi+rlSbB74kEHPjxTkeI+Xezx15cwmR5u2WuJHZ1UmV4z//B34z9KvMTOVJp59FQvALBFPBof6Kb7yCqp3j3dmTJJCwnHMZaX7hy73ArkOg1Kd4UFeDJbpuLnT13gAUdSWERsX1oSLJIFXIA8fnhQbBIAxUrtlyfRTmw3bfE40+zLTg1tuxd8ARjCXNYe2uz6ZPW/zVPaI8QWIbjxXe3e1h9Jww3VJi0jPzcPwYAjqLn18HCPD15y9VkMnRO9eeqqRMzRxXIikt6YnmSEGfL44HOuIZHJ+0J3TKFd9alnZ2AxmcbPTgTM8fTFfGN5RiKXFjVmPPoA==
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 007a69cd-62fc-4ea8-1f3d-08db05796e0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 23:58:49.8189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f34wTJ/UP5LVce7kh4SAFHtvtioIvqt9k8UpwIQIatHQnxe2QlSZR9mfXCLQhuFmf3HeVCdn/2JE2PQg6pimSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5289
X-Proofpoint-ORIG-GUID: FE2DeTmBMZ3TfhogPNv0tl99dhaEuua7
X-Proofpoint-GUID: FE2DeTmBMZ3TfhogPNv0tl99dhaEuua7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_15,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 mlxscore=0 bulkscore=0 mlxlogscore=808 phishscore=0 adultscore=0
 spamscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302020212
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCBGZWIgMDIsIDIwMjMsIFRoaW5oIE5ndXllbiB3cm90ZToNCj4gT24gVGh1LCBGZWIg
MDIsIDIwMjMsIExpbnl1IFl1YW4gd3JvdGU6DQo+ID4gDQo+ID4gaGkgVGhpbmgsDQo+ID4gDQo+
ID4gDQo+ID4gZG8geW91IHByZWZlciBiZWxvdyBjaGFuZ2UgPyB3aWxsIGl0IGJlIGdvb2QgZm9y
IGFsbCBjYXNlcyA/DQo+ID4gDQo+ID4gDQo+ID4gK3N0YXRpYyB2b2lkIGR3YzNfZ2FkZ2V0X3Vw
ZGF0ZV9saW5rX3N0YXRlKHN0cnVjdCBkd2MzICpkd2MsDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgY29uc3Qgc3RydWN0IGR3YzNfZXZlbnRfZGV2dCAqZXZlbnQpDQo+ID4gK3sN
Cj4gPiArwqDCoMKgwqDCoMKgIHN3aXRjaCAoZXZlbnQtPnR5cGUpIHsNCj4gPiArwqDCoMKgwqDC
oMKgIGNhc2UgRFdDM19ERVZJQ0VfRVZFTlRfSElCRVJfUkVROg0KPiA+ICvCoMKgwqDCoMKgwqAg
Y2FzZSBEV0MzX0RFVklDRV9FVkVOVF9MSU5LX1NUQVRVU19DSEFOR0U6DQo+ID4gK8KgwqDCoMKg
wqDCoCBjYXNlIERXQzNfREVWSUNFX0VWRU5UX1NVU1BFTkQ6DQo+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgYnJlYWs7DQo+ID4gK8KgwqDCoMKgwqDCoCBkZWZhdWx0Og0KPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGR3Yy0+bGlua19zdGF0ZSA9IGV2ZW50LT5ldmVu
dF9pbmZvICYgRFdDM19MSU5LX1NUQVRFX01BU0s7DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgYnJlYWs7DQo+ID4gK8KgwqDCoMKgwqDCoCB9DQo+ID4gK30NCj4gPiArDQo+ID4g
wqBzdGF0aWMgdm9pZCBkd2MzX2dhZGdldF9pbnRlcnJ1cHQoc3RydWN0IGR3YzMgKmR3YywNCj4g
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29uc3Qgc3RydWN0IGR3YzNfZXZlbnRf
ZGV2dCAqZXZlbnQpDQo+ID4gwqB7DQo+ID4gK8KgwqDCoMKgwqDCoCBkd2MzX2dhZGdldF91cGRh
dGVfbGlua19zdGF0ZShkd2MzLCBldmVudCk7DQo+ID4gKw0KPiA+IMKgwqDCoMKgwqDCoMKgIHN3
aXRjaCAoZXZlbnQtPnR5cGUpDQo+ID4gDQo+ID4gDQo+IA0KPiBUaGlzIHdvdWxkIGJyZWFrIHRo
ZSBjaGVjayBpbiBkd2MzX2dhZGdldF9zdXNwZW5kX2ludGVycnVwdCgpLiBIb3dldmVyLA0KPiBJ
J20gYWN0dWFsbHkgbm90IHN1cmUgd2h5IHdlIGhhZCB0aGF0IGNoZWNrIGluIHRoZSBiZWdpbm5p
bmcuIEkgc3VwcG9zZQ0KPiBjZXJ0YWluIHNldHVwIG1heSB0cmlnZ2VyIHN1c3BlbmQgZXZlbnQg
bXVsdGlwbGUgdGltZSBjb25zZWN1dGl2ZWx5Pw0KPiANCg0KQWN0dWFsbHksIGxvb2tpbmcgYXQg
aXQgYWdhaW4sIHlvdSdyZSBza2lwcGluZyB1cGRhdGluZyB0aGUgZXZlbnRzDQpsaXN0ZWQgYWJv
dmUgYW5kIG5vdCBmb3IgZXZlcnkgZXZlbnQuIFNvIHRoYXQgc2hvdWxkIHdvcmsuIEZvciBzb21l
DQpyZWFzb24sIEkgdGhvdWdodCB5b3Ugd2FudCB0byB1cGRhdGUgdGhlIGxpbmtfc3RhdGUgZm9y
IGV2ZXJ5IG5ldyBldmVudC4NCg0KSG93ZXZlciwgdGhpcyB3b3VsZCBjb21wbGljYXRlIHRoZSBk
cml2ZXIuIE5vdyB3ZSBoYXZlIHRvIHJlbWVtYmVyIHdoZW4NCnRvIHNldCB0aGUgbGlua19zdGF0
ZSBhbmQgd2hlbiBub3QgdG8sIGFuZCB3aGVuIHRvIGNoZWNrIHRoZSBwcmV2aW91cw0KbGlua19z
dGF0ZS4gT24gdG9wIG9mIHRoYXQsIGR3Yy0+bGlua19zdGF0ZSBtYXkgbm90IHJlZmxlY3QgdGhl
IGN1cnJlbnQNCnN0YXRlIG9mIHRoZSBjb250cm9sbGVyIGVpdGhlciwgd2hpY2ggbWFrZXMgaXQg
bW9yZSBjb25mdXNpbmcuDQoNClBlcmhhcHMgd2Ugc2hvdWxkIG5vdCB1cGRhdGUgZHdjLT5saW5r
X3N0YXRlIG91dHNpZGUgb2YgbGluayBzdGF0ZQ0KY2hhbmdlIGV2ZW50LCBhbmQganVzdCB0cmFj
ayB3aGV0aGVyIHdlIGNhbGxlZCBnYWRnZXRfZHJpdmVyLT5zdXNwZW5kKCkNCnRvIGNhbGwgdGhl
IGNvcnJlc3BvbmQgcmVzdW1lKCkgb24gd2FrZXVwPyBJdCBjYW4gYmUgdHJhY2tlZCB3aXRoDQpk
d2MtPmdhZGdldF9kcml2ZXJfaXNfc3VzcGVuZGVkLg0KDQpUaGFua3MsDQpUaGluaA0KDQo=
