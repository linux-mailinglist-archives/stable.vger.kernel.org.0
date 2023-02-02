Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894056888C0
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 22:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjBBVIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 16:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBBVIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 16:08:41 -0500
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E7C70D73;
        Thu,  2 Feb 2023 13:08:39 -0800 (PST)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312IkOp9030819;
        Thu, 2 Feb 2023 13:08:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=bQCaEsye/MW6i+u2xgcssTNlZkDzjjpW0G3Kv3GBIK8=;
 b=cwO+f7Mf8TWpeFvz7coaZpW8UQV9itiQ+YpuSvI8HfO8e+u7ET9RRKdlnU/HUjygldjp
 yHBdeKIA8/+N99sfdjd+XgbcRdt3ORbmSGiBrJYHJg2sFyPw0jXtRBNBqJmtul33X1if
 eftVjBF7QGOuDQ1V26IfdoLiffe3aU1ENZQR6io1a7rHYFAwYyADoAub2JsMx657lgfS
 n4eUmwN22wNN4zL8UW2/RWHre/oCR9GejSMweavMjgSNzJeyK56FY7YnbmpYBKmyDL94
 w/kUZ5rMMOIwA3gqna54NdNdC+VEeEpfh18tUfBkS6eS8FeKMsnqkLViH75pbWZ7aQ4y Iw== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3nfq4nrbqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 13:08:36 -0800
Received: from mailhost.synopsys.com (badc-mailhost4.synopsys.com [10.192.0.82])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id AF4A8C0ADB;
        Thu,  2 Feb 2023 21:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1675372115; bh=bQCaEsye/MW6i+u2xgcssTNlZkDzjjpW0G3Kv3GBIK8=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=HU+hFz+bJC2701x6nWuD9cjdqM8xcvYs4W6u+ZQZFPN9QsA5lWIVQ7aMnHPsJOVA5
         88aI8Xr4bzoaWeVi3y3+Aiep/uYbMeoE4BCKvwLYYJpYlljyu+/JzEl3M9W9ZJUw//
         M/7/F/lR7n9CkEj1Z2iurl085dpceXT6Wqdk/5gsMCrll96JplgsEpg1Ld71oEs8Bq
         cUIZ88Sj46lpKmiusqbWlpb59Vb8BitIpWQzqdV28Wttsl/Dmdx1QQKQzNx7ZdHkVQ
         RiV2su2024k+d5PI0NL521NEnKxJ0D1H42lBSnytv566MMPYoNtL8fs4Wc+/HBcGLx
         t7gJ86Sb7GvRQ==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 59163A0073;
        Thu,  2 Feb 2023 21:08:35 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id CE6BD40106;
        Thu,  2 Feb 2023 21:08:34 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="MYu6FXw1";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITczWmfAOt6cteaRQTRNcqxI0GYZnCshDSACDXwv9jhl6nckrpy7xUjmxsLUOWScqpwT5UZkEJxVQ1PE7hMB9IBcjAs5bwDRvr8xjTejN3SLX7v07tcJa/rEMVzG81dtq6AZCmt0Xgkr8veaSXcEbRTCCNbgVnXOI9qZCCa74cOW6658JZ0altjvExGBZrc0n+oX36lRKZnlNN3XU/yCFs9xhm614vCQbVnJdLu7455MzJzIEKJgYWUq4WsBVLXb3LoasReEYvMPrCN4DTsB9XPdsTylx0pDPz0hYMVthEYfQaMnmWObnGq3Yg1amxT1U9+L236YuIJOI8g/rqc74Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQCaEsye/MW6i+u2xgcssTNlZkDzjjpW0G3Kv3GBIK8=;
 b=fsVLYfGWawgjfI195Yk8/ucu8FdADLMBXlcSOi7AFO2IOpsSvnKl0Fsu6V3frRJC69nCdwHGGRa5JjJnibczrSWV8RVn6x3CEX7yW9gac/RuXdTqWWDmiTaF3EaEHwakvJhVOB/eN/00/FAfzu9MXhxXHx0gO7pXtYA2pslfNxYFKOlC8OkjOAOudh5iscPbPsafbrOIQ+UuUGY0PklWuRI38KAae9upcCDOQ+bPVWczvyExk5pKu4WpN6TZ3jltKjlEhVFFtXyIsT5br0IrY9eIMoDpYFMwndYHKAO5G/3c7RooMP+SmfD86cHXVIiXVSYUVLLAmWSwjswdGAB/fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQCaEsye/MW6i+u2xgcssTNlZkDzjjpW0G3Kv3GBIK8=;
 b=MYu6FXw1VOaOL2VqY8xTEmZNJ04nGapdejygr56nBX0wkUONOTGNEAboC1Emw9GKA70eTna8jihWNXbABh4eTb0yaoTmuIbt6GWqVbHllRiYhHHcWuQyHgn1Hl9qCK/kphgRBdXE7ijxboFqxtnmcdJcHb8webIGhA6onilfNS4=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BN9PR12MB5083.namprd12.prod.outlook.com (2603:10b6:408:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 21:08:32 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::6f3c:bd8e:8461:c28c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::6f3c:bd8e:8461:c28c%7]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 21:08:32 +0000
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
Thread-Index: AQHZNetg1e8bWR5O+UmEKJODDDA7p666dI4AgAC0WYCAAO/lAIAACEoAgAAIDYA=
Date:   Thu, 2 Feb 2023 21:08:31 +0000
Message-ID: <20230202210825.fxk6evunmkpwnz77@synopsys.com>
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
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|BN9PR12MB5083:EE_
x-ms-office365-filtering-correlation-id: 422ab0a5-e7fa-4139-d41e-08db0561a3a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WFHZp8RjJpoSL4L3w8EaTrZ2ZArmRfJNg8qebyqB6tTMatLIZ4z5amG5PADssKnnYCgGgj9LQtegCtjDLyCMzQBnDydPzejO68cH73p8jcji+/7dybfZy7EbMxz//WOH/5ibAhrsuod1QgpQPU8hvBTfy7/AT/P/9seGjrNvAzV7SnmvYX9pW3v6Z+Ru+iLI1V7jeY9AJD/ebq83zRiGhMRJEZNWwttF+/wvJXfxx+iWv1frNeLz4SVABtWa0jOEU9kGdZA5+dd0hIDNkFQel8zTscBrGq9B3efNTU+Vod//cU4VwSrX4H7U1xGJFz200ryHk4VVPzuSgoJqlU/fShy5vuziaBLYDLt9qan8BEJroCYIvs1aB6biHIpy2aVGGh/hnmod74XSb0ruWmEwMFd360Lhj8T/P7ESODr8e4v9VuxjYEfXtBDsu1nx/NRFrcj4cYrHLyUbMnNdopxSnHSvypNRioLznkBYSHlnXUkqwlbXk2hpY44jLORC8NR4Sd4Mk6AuqvbN/EMtvWOtYYQVx43q+I+zuoufTpt/sOYnkaWZFjE+sIam0JJuEdElQ9lN+XD+p/l5bgWn3HjKFNUNNVdbQEYG9inRE3y9ZRsJ0JbQbzNcu5m2KNLPNTaQ+fbyANWrq4W+99GW08hKTtgE1JNJqTU/Li2P1D2N42teAS3+8hEWUkmVt6qFtiaMhDIfD7xJOGQNmvcV1DwU/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(39860400002)(346002)(136003)(396003)(451199018)(5660300002)(41300700001)(2906002)(15650500001)(76116006)(71200400001)(66446008)(316002)(64756008)(66946007)(66476007)(6916009)(66556008)(4326008)(54906003)(8676002)(2616005)(6486002)(6512007)(36756003)(478600001)(186003)(26005)(8936002)(1076003)(86362001)(122000001)(83380400001)(38070700005)(53546011)(6506007)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b1QvNC9pSVpQT21uOFVwQXlJb1U5M3hQRWpUa0NsMEU5cEU5K3BHdkNwL3Vv?=
 =?utf-8?B?MHpkdFJyZGlrZnNiL01tWjE0YWVIdWJOUWt2alEvS29rT3I1bHZtazBHKy8w?=
 =?utf-8?B?TEVUdEgxUnhkSVdwblM5N1pzRTB5QzBuenViRUIzVXpCWVZmanM2U3gxaXNI?=
 =?utf-8?B?b3dNVmV3YWFnTmtjMkFRTW9BV3VRaE5KRjJVOWJXQmhDLzVJbC9CbWZiMW5r?=
 =?utf-8?B?TjVITnZrbEY5akcwVkp3R2wyNzB2L3hnaE44UGF0cjZGakRLREU4dkdRbjNt?=
 =?utf-8?B?WDBoR1E4TXFjNHJrUE0yd1Z3QzQxWkg0bC9qRFJPRFhlNnVEUnpwZ01GazJG?=
 =?utf-8?B?Z2pFaVJtb3MzMmxZdmdvQll2Z1lyeGtCdE52aGRvVHlqK3ZOQ2grSm45czZs?=
 =?utf-8?B?L2tSclBKd1RTakFqeTVaemNCc3kvVFIxZ1lOMHU2SURUYWxlclU4TzRHRmR4?=
 =?utf-8?B?S0xhMnBML1d3TGdha0hqd1Z0cFYwa0ZWc3YzSGdzL2ZJZE5rQXJkVlI0aDEr?=
 =?utf-8?B?dnJvMmhBRmJ5bDNKYS9Oa3dKbE1TaGcvWjJZU0ppYUFJMFlSeGU0bVVSSm1Y?=
 =?utf-8?B?R2NOc2NLdm9qWWM3b01wSzdESXJZMFVIb0pvcnh3SVRIV2l3M3VhelVLVXZj?=
 =?utf-8?B?TDIzRlZvckdxcWFRWHRqTzdsV3BrTUNITGNubEVvTUZXTU92Si8yVkNVMkxn?=
 =?utf-8?B?ZmluRUlRWXg0dUpqdnlxeWE2UzRWOWhwRGRPcTNrWVV2bWZibVJZWVd6b2Jw?=
 =?utf-8?B?RFVzWldIVG9pRnR1em1RQlhJOGlJRDZZdVRWaVpDQXRxcTIyNDBoVkZ5cGkz?=
 =?utf-8?B?QVRJd2d2UWJObUM3RzNJcVNuMWNCNUFwWlJaRHR6Mk8vZDZYNGpGTVVhQzdK?=
 =?utf-8?B?ZFoydy9JejhCQzcwK2l0R1ZQUlhWVWUzRGRUYm44QXdYVCtGcWozZTdXZG5i?=
 =?utf-8?B?cGRiZjBYL1J0Z2xHRUFCOWpYVXlsd2x0RGdDcm14RVRHalNFVDZ0dnRNcFgx?=
 =?utf-8?B?OXVWQTZEQ01XQVpxWHpWeG9aVFJ0aitOZCs2WWdjbG83TElXemdDTDhEZVpx?=
 =?utf-8?B?RDFvZ3ZtOHRnN3FuWHRnWE0wU1dmQzNiTTRHTGJGSVRQTTlPMTdEdFgxamhy?=
 =?utf-8?B?WVVEdUtoMFBreEl3M0RQbnlodmZ1bGpnN3pZUWZDTTRVZnlMRG41VWtJUGRZ?=
 =?utf-8?B?T3U5NXcwTjlkN1Z6TDZEdHpmR2lsV3JjVzBib2ZRRlNocFdMQTB2emg1MExI?=
 =?utf-8?B?SjBQQU91cnJJRTdZRFZ2dXYvUURLeHVUK2VIN0t1LzJORy9KWVBpdkp1VExr?=
 =?utf-8?B?OTlab0RSSmVKcEorVGRKUG1nRmJxUTNwSlpHLy9YVTVCM242b09UM083TlZq?=
 =?utf-8?B?NjZYdjFaZ0EvZ2pZSy92dVVMOUg5V3V4allRMnI5clNEMndSdVZSMmZzd0Fo?=
 =?utf-8?B?QlZkcGxwTnNpb2RxWkhvZmd0NmFmR0xGc0ovMmdCenVhZWROL1hKUE1uRkF2?=
 =?utf-8?B?YXdUaUc1SE8zRGphR3Q3Y2kwcG5ibTI3K281UCt6T3RvRDNsQUYvcWRVK1Y1?=
 =?utf-8?B?RnBoMEl0SUJ4Z3YrZlNsSDZHNG1VdTJaTTBicXhXcTZ1U0lPTitRZ1JPTGV4?=
 =?utf-8?B?QU5FckIydGF4UXEzbW1FQW1ZRm5mczkvVnNOaFBiOCszU1dHY2VRUG5pQTFY?=
 =?utf-8?B?YXhmZUNtZ3dUQjN2RzV6bTZ1Zm5GWDhoQU40QWV2Ylh3OS85Ry9qbVpGbXFE?=
 =?utf-8?B?ckM2TElOcUkvUXY2a0tteDRsSXpBd1hla01JaU9Xa25yTjBTMFliei94VitK?=
 =?utf-8?B?YSt0SFVSRnNGcDRCc1psWVA4aEFUL2NTaVNQUGhTdU9uOGNDTEJZYzdtS3ZW?=
 =?utf-8?B?VjVhV2U5VHlpYUxVTGFCZ1JmWkIvd2hWd2wrbzhKSG1NRTZmYjNZMkduTm1o?=
 =?utf-8?B?ZUhMOGNvczNPNEhJQ2FQRDlpcHJHcFAxTnI1RFlkRlVoSmtKanB5TkdyR0RF?=
 =?utf-8?B?b1Ztelo4RFprWTNITExjeWJydm1CUmtsSnlTLzQ2MmZFZ1k2SjBIM2hNUzBu?=
 =?utf-8?B?WkFkVmd6S3VZeVZVSEM1M1pXWVVCM29neDZtL0p6NWVMcDl1VDhSLzhrMVZn?=
 =?utf-8?B?a2MvOE9Ed2VnQVkrKzRGeXNtZGpTZmt6eHN1R25wdUQwYzRIUzVTN0tPNmpJ?=
 =?utf-8?B?aVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD41AFF84A93B44D817ADA16F145CC00@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: kSr0OCWsXjG0OScbDd5VzUys4UIBVJLeP9RZnlOeZ3HZMzHz4xMzroEdYDZPo2E6FZc8TTobY+YirYHnnpoI3yFRdVd5h8XfhBvmI064Ghuqx0AJX7L+yRB58iiZFyHsiCykA7lvk0SgZdoc4e/9CY3np0IoSWrqpAjBcpf4yZsGx415+6lHcPvP4M+Ol8Eckoy6V4rLc09Vs/b2KxL88vXKm95Ep00HYt71+VIC/Czr1NFiIEunJrSVBFoC8t7FuUMgijA9FABw/F15MhPpJnriMUJ5dkb90g/WWya4JhYqjE0YA0poVCiy/EJXt8z/f7k0wk/ShtR+iU1G8TLZhJOn0ZG3492EflcMaN9OCzsK2m2acKlf59IvoeOMW0et29veoeehuxgRoDucrM1bdN0+jzSXwS9ecZkZxKCgsa88fd0cuL2DBzaeM6IQ3D/3xxUZERwsoHGMsr7J2c6435ReAs8Bv7mlr4ahm4bgowleUNrjBrhQJVjvzhsEjXlL25fcR/l6CmBY5zXGmh9zIgbynvl3x/WZWxnlnb5zdTIU5TRa254HwHJVJJazbXbS0gTi1Az7I0P+ejnsMe1AhAoJcB32Hast9BJSWxVYlwUGv3QebTA35itZnDQ4Y7FvrBhg/srVl3KNabUBouuciCMrFNzACpw9Mbp2OBZWZL516CVDmpiJSzLJly/DrDKKBumeUMKGyAP1OK6dZ+ncjI3T3bYjgMvGRYbETOPf2ukVGA1VYAWfpVqQO3DoQ33BYHSv0mMv3WiDBvI030pZHUXBtFgeesCA3yqbb4Acma+Kaw21R+Iw78RhvXW8GBZgMxx2Ge1Bo+WyjEsiuF5L0rTbzMXkeDLQF+IBjXKVPdn6w/jZu2V900FcTzKXSp9P
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 422ab0a5-e7fa-4139-d41e-08db0561a3a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 21:08:31.8149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hqSLmANqna/0D06W9aQ0p/VM90JuboXTdEiBc1JHlqhrpMn2XbneQ2dHy8slzrMObcrTNp8VOtatL3VgL7Jm0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5083
X-Proofpoint-GUID: girWzUTktjJcfcAcxt5yHXynvHQkr-lp
X-Proofpoint-ORIG-GUID: girWzUTktjJcfcAcxt5yHXynvHQkr-lp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_14,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 impostorscore=0 mlxlogscore=483 mlxscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302020186
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
cmVuY2Ugd2hpY2ggdGFnIHRvIGNob29zZSBmb3IgRml4ZXM/DQo+IA0KDQpQZXJoYXBzIHRoaXM6
DQo3MjcwNGY4NzZmNTAgKCJkd2MzOiBnYWRnZXQ6IEltcGxlbWVudCB0aGUgc3VzcGVuZCBlbnRy
eSBldmVudCBoYW5kbGVyIikNCg0KVGhhbmtzLA0KVGhpbmg=
