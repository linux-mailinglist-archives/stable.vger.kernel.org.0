Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259BB688850
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 21:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbjBBUi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 15:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBBUiz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 15:38:55 -0500
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CAB719B4;
        Thu,  2 Feb 2023 12:38:55 -0800 (PST)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312J8U11028316;
        Thu, 2 Feb 2023 12:38:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=eNYL60n1YuvDVUv3+IVVoC2Km0CjA3CBRHSgGIRMSBE=;
 b=vHO7dgXBFLKyzotdybS1TIpDKwUDCELdwAKtCt4zRPFTSeoBfS6wvJ/aCB5u2jsC1/Ev
 cmh+vYV3P1gukLukVRRgHbBhVpt0f7JXjo3Fx5vl8nXR22BBrP83u+1xtW9cfY/5iSH+
 fnjxHjkPJW1NpAnZC7q+6slhAVHn2fFoy7kEBrzA4BM/W7xmJAmj/m9ZbvBy3VfMWFMs
 3EpABTikfYBG1v+cBvlxs31i1DLNSTxeAsF7x3DBv5ZC2jhLGaYIp2hZRk0HZmZVtNPq
 maR7RJH/jTijF3Nc/0PhFGwpHIa1aujMh/KscG5Yx+a3gY4OVPHsE7+p12kQaVijwGMV Lw== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3nfq4nr7hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 12:38:52 -0800
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A7456400CE;
        Thu,  2 Feb 2023 20:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1675370331; bh=eNYL60n1YuvDVUv3+IVVoC2Km0CjA3CBRHSgGIRMSBE=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=JBFBxy+zH0cdFgAob52vtug7RWveQ/v5AV7aBvyFKDDEVbGL+RavPkJkeq4HMhVEF
         iveihni5zR+sZq1RwMYY/tpHeloZSDDkoCD8nAnEf31PSbCDU37rf6JCaqrgfsNKB/
         V4M296g6HxJDQhJz+TAcaLkn2maQXWBzDg8rOMUCoJOU3+dOLRUcZXSNon4cIBY/no
         +nJ5PbRNwgFJH+aP9VX6NAXsPz47TLybG07Gx4Lavw+cV7G+4kH0s/lAvh4qbVcC0V
         SmQ79GB7D0DeKvaR+WPt8iyAZc+EbDrGT4RYv6qrVKw56jDEi3Memw5dbfJR+KJ6zE
         DH8Kne29UCheA==
Received: from o365relay-in.synopsys.com (us03-o365relay7.synopsys.com [10.4.161.143])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 32374A005A;
        Thu,  2 Feb 2023 20:38:51 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 9F535A0093;
        Thu,  2 Feb 2023 20:38:50 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="dhm2EFtr";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzcSH+Xuu/9T6pn42r+lHgy6NG7ka/Fu2Opcqh0FBUSOlK9eougS61QxU/Dq/iRWjHhmMUl5AxlKqRx3N2dMFhIcAyWxX529y0BxsFFMQQoztVK/PkWxsAdhefKLmHH65NuFCvCnZ3hUP9AGlJ2oLXEt3eTQQozIJj/ed88xtCGBVmXY0l5XWD2tXzDuDquQjoaI1XQzAfCbotDMwiZeQ7fnsA4jbgaDJ6l0Xjme806FHKRMFX5f9OK85fW6gU5RbCTmYRD9YNOPoWN7gVhVAqdNniq1KUPPwqD2h5ZkiHkiD0S/PO0WLuorBSi2SNHnk7I0/oyws2btoOs3bLlqfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eNYL60n1YuvDVUv3+IVVoC2Km0CjA3CBRHSgGIRMSBE=;
 b=A08fco6kTCzJyuJusDGD163A6qfFcYSU+1Ue+7tLmXmRu7u9y313Jb3YGmiixtkJIO0q+/RLRIJzDjcAZ89yUjq08nSeYfxZ0hJtHP4/RZNGxbYV26wnDQlCaELqxUxIPAFnMNkyAPwBWuHx6JLuHicmp+lw0d810MBnGcLoHAdq4uOJ9Phv2H7Q7MITUXR+P/+E/HSWIthHQVEqvOzCYSSiD4fP7t/TuOVo0V1t1o/wWK6Rfa06egTmd8X8HzwLOrxnhEop73ZlAP35LaEIXomHHU9FTkc39IT6+FxbqYuXZAc/5bX+jpJiuTdr3v9ddg/RdiZ5yHhif4XBwwpwsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNYL60n1YuvDVUv3+IVVoC2Km0CjA3CBRHSgGIRMSBE=;
 b=dhm2EFtr1ZGgpW8yGs7a3jKG1xq5yl/eqSvZS8cRQQfP4bfdPlXDmnnxNPzgsk2HKZ0/eQaUazlRmIeK//Pkmuj7o4ETqskHIF8Xqe1A9iGDA+v8DdWVic4bSCr4+uONYx2qujEd1PTNoctYFQHj9tCIOl2EO6RjkWHWZuiau/0=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by MW3PR12MB4444.namprd12.prod.outlook.com (2603:10b6:303:5c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 20:38:48 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::6f3c:bd8e:8461:c28c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::6f3c:bd8e:8461:c28c%7]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 20:38:47 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Linyu Yuan <quic_linyyuan@quicinc.com>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jack Pham <quic_jackp@quicinc.com>,
        Wesley Cheng <quic_wcheng@quicinc.com>,
        Elson Roy Serrao <quic_eserrao@quicinc.com>
Subject: Re: [PATCH] usb: dwc3: update link state when process wakeup
 interrupt
Thread-Topic: [PATCH] usb: dwc3: update link state when process wakeup
 interrupt
Thread-Index: AQHZNetg1e8bWR5O+UmEKJODDDA7p666dI4AgAC0WYCAADgqAIAAv8OA
Date:   Thu, 2 Feb 2023 20:38:47 +0000
Message-ID: <20230202203841.5vxxtejol3zyjjef@synopsys.com>
References: <1675221286-23833-1-git-send-email-quic_linyyuan@quicinc.com>
 <20230201190550.jozzrvwdi5lcwtbo@synopsys.com>
 <197a1446-9382-3d83-d26e-694e4d707679@quicinc.com>
 <d6e66c50-421d-f57e-fae3-1a4e14dce780@quicinc.com>
In-Reply-To: <d6e66c50-421d-f57e-fae3-1a4e14dce780@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|MW3PR12MB4444:EE_
x-ms-office365-filtering-correlation-id: 0ed49f56-217b-4099-3881-08db055d7c18
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wuvBoqPg7QFcZjpSs62QbF1KG1zsBiR98mMGVR+tVWcTm+XerEpebKHBxk2v/WaKR47zHMuSjaBOnt9hyQDyJ70+jC3aOEMD8OjrMwJWbS6MbqPtGmfva1/B5k8kxh8f4xS3Z9ikscTxg+RsMxRvAbEckJorJyn+Mc2z7ONkhZY2hkaX/I/eA/Ezb6MchCTpUcw6CHmBahzg4PZbpMbuPiJ8GSpIVGmQZrTZBfdx2F45jzATAg4B+wvEM22IAPlDlbZELWkusSK6nwtPB1dIgucTc9WrIxP6SocL+4og4QWOAWFX5tSCec0tC5PCkjSHQFtiD9IOmSynuFy2q7rhx9mPqDk6u7tquqKeUXLn4NLH4VuYgPFdH9Do32trHecT9FhAOMzvEVXnpYAzlOdQfeW3MOzSUlKXsyHH4D+ZPmWJjxnLYVcxYsSgdDkksejVdJuLs6vFJu8MRex5QzjmrKT8B/JQF1sexTyzzXacPqj0WmL7ggpLwnNE7BkyrINIw5DG2g7tB6wU2DLU5LFlB1vaWAjBykGWX9aTGeZC6cSiVJqSWcJLIvalFaLuQfbF5e7+S7Z9jq1NHoGZagNbcw78bOGxI2UtRhKivLhBGGSSdVHiEwxXdbMWeSUrP9A65B769Xqn4UBKmWG6m4INEUzmc8Bwy9XBQRgYi5vQHpEK+lJeQqyO9EDsWMbIGf3rtocYSF4w03VXkkm4TpH03A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199018)(66946007)(76116006)(8676002)(66476007)(6486002)(478600001)(26005)(54906003)(6512007)(36756003)(6506007)(1076003)(186003)(316002)(5660300002)(86362001)(15650500001)(2906002)(8936002)(41300700001)(6916009)(64756008)(66556008)(4744005)(71200400001)(4326008)(66446008)(2616005)(83380400001)(38070700005)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aGU1YjlUbDV2RElXcXN1dytHM2ZzNVQyZU9QQ2hyNEtqeE9rdHFaNVdlbE1F?=
 =?utf-8?B?aUdJV1NwVS9Fa2ZWenVmSjBaTi9PSXdnZ0pmV2djWEYzUnFNOHEzWTk1aWlk?=
 =?utf-8?B?QnU5VFQ1Z2RmYU45RE93S3E3dWVJVGl1eUd3QkJidjI3QURLdFVBWWhpdjJK?=
 =?utf-8?B?eHA1dnpLVVVEbFhmUEZjczF2WTlXMTFqSzl2WWI5eDRraldtaXJoaFVwUG8x?=
 =?utf-8?B?YnlZNTJzeHMzbEVJdzJPK1NxeTBGWWRCVDROOERvMjhYTWt3ampVRVBPUHEz?=
 =?utf-8?B?QjdrMEpWMlpQc09OdEZpNEdwV0EyYmtLUjRpKzl0NExQYlBYSjBLZ1hPeVJ6?=
 =?utf-8?B?MlFPQzg3emFrWTByNk9taVpmS29rWDJxQ0dTMnZIdXQzZU1PY2NsNGVqQk52?=
 =?utf-8?B?dHdwME5vOGlSZ1Q3T3ZxcGNxNEN5eUpJS2p0VEpIeWdVL2RrNU5iVFpkZGZj?=
 =?utf-8?B?YjZjTWRXOGw2TCtkeU4zaEtjZEttWmFBc0FTd3Ura2dTQkhBUklTUzdZUGJM?=
 =?utf-8?B?cjJZU2VQR2JxUWl5TDJoZi82cFdGUWFua3ljaVovZzY3Myt0bVBJclJhQk51?=
 =?utf-8?B?djdpVVZPN242M0xPZ0kySmZla3ljWiszZW04K0hCaEE3aVZqV3ppWGkvT1Iv?=
 =?utf-8?B?bWxWN3NvTkpNVjUxRmI5UmJiZlhua1p6ZndJU1JqajYzeWhMT0NWYTh2TWhE?=
 =?utf-8?B?eHZFb3NCa2htR251RUlHbG5QZ1FlU0UzYVB2dzFrL3dUU0xpSEwyN3l0bHBZ?=
 =?utf-8?B?WkdZalV5RFI5ZlJVd2xPY1lUSWg3T2RnalM5emdzSDNURFlhY000TVRLV2JB?=
 =?utf-8?B?Y29SZlhhSHUvb0R0WTJsR0o3eFNGTE02aTlxTkZLdXlXUityQXJ4TUM1cjFX?=
 =?utf-8?B?cTQ4UnkyMlg3TWk2MTV4Z201Z0Qyci91SVhlM3FER3pPcFpDbjNmc0VjQjVY?=
 =?utf-8?B?ZU0waE1ydDQrRFVFOUpOSkpadncwVUpEK3d4RFlTWXVQcjNhbjRkdFJ1dlBi?=
 =?utf-8?B?a0NlMmltM3VuMFRJTUU0SUYrY0RFU2FKMWVOSk9peVl3WGwzNUpKS1lVZ2FG?=
 =?utf-8?B?NTErdllvTTZyd1NuRnlReWlpVDdVWm5HYk1CU21iNkNDZHNBVi9GTUFFWTYy?=
 =?utf-8?B?LzlQWWswMWlRVGg2UnJtU2N3SjlOUFBCV1Z0UzBnbWhyYXRyQlZXaUE2MzNl?=
 =?utf-8?B?UjVDd1IzTVcxWTQ2TTVBaHRJbFZ5dm1GRS9Nd1RCWjg5TncrZXo2WDd4cDln?=
 =?utf-8?B?dUdFSmI0K3VtNGNwMHpOYTZqT0p5S0d0THpjR01rejdaQURiTkJlcmtYNWlY?=
 =?utf-8?B?QzE3SkVOVnRCVUpCclZ3ZmxqMU1zaGdqRkl5ZjZ1RUs1N2VwbStkRy9lT1E2?=
 =?utf-8?B?Nm02c09xaUpGaUtmdGQ1czFYWVRXNTcxY1ovekl3M21EdHZRSmM1V2s1ckFS?=
 =?utf-8?B?ZVM0Mm5lWHRURC9LSUU0cSt2NmZKUmN3dlN6Y2hLaTF4K2xqdTRyYlNiZ3Jn?=
 =?utf-8?B?blpYczVZS1U0WHhwR2h5ZFJCdmRVNGx6eHVYQnVrbmdDNncxU2Qxdk5qY1Yy?=
 =?utf-8?B?T3RmQ05CTGRWbDE0SlFCSjhZV01uZGhMS2ZTSkpOTzl0M2x4RmRJQUNpWm1q?=
 =?utf-8?B?SHZDcUYzdEJwMW0vdk9ENSthZ1ZQR0FJcjN0YldGQjJVLytMc2NZU3FHaEMw?=
 =?utf-8?B?V3RhbHgrV1dXZmdVMWZBaDMrbjdMb2cxNEYvamlwYjZBNGVkNS9vU1N2d3Rp?=
 =?utf-8?B?akUxVGhYb3ZPVnlRNTR2dUxSS2VxbEl5Zm9yMk1paTB4ZFJqQlhZQzJXWDFh?=
 =?utf-8?B?L1g2emhSeWxIZFdpeTA4TEhEY25rRkZ3eGJZZHgwU2NWN3RWeVBQN3FTZVk0?=
 =?utf-8?B?em4rOUJTU01XUDlhVW1NZ0NjbDkvZkVMQTR4NXlYa0hyV055bVQ4QXFkajFK?=
 =?utf-8?B?T1ZVT01qTUtnNlhCaHg0K2s1ZUlnbW9nSHpiZVd0dHBlYThJN21od0Z1bVh5?=
 =?utf-8?B?djRKSG9uOXFSd3Z6ZXlObUpRTHhNMWFoblNSWHlkaGdLRmdSZXB4V2ZLL2FZ?=
 =?utf-8?B?ZWV5RmtFTnRCZzFHMEJsdXNGQjE4NzFucW1mUFhoa2FhdzJHQVRXTzcxUGZl?=
 =?utf-8?B?NkxuclFzTk1tWEtiRjZEU0h3eFhUWlVKMk1BNmlyeVFXMUY5ZG1PcEF5QkVy?=
 =?utf-8?B?TXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C900D949EA8F53488A33D812F5330BD8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: CSAOPXCpqhCy6f9c59C/IRLPWNZ9tPK29yH7Wsz3Rzcl0X6os0lzMaMZ5AZCL0Mb0cnuFClkPzMRjv9Yh4Mfyz+0ycGiISsUcSUCSlTM+vfadg8GQ9Zr7MLSqFBNTow9ka3ESwLpnlnsH/4K5fZmmzVcQbMun391L1ZBUU17xPHBi0Qzxfvfy2KBQb/5mqDGS5gzCGCy1RbZ9U7NEFJLk3NMARPu7ZzNT1htkCm3U5F/YSwDd656X2JBlab69+JlBKluQRvYdNZFMh4lDpX3dqoP9YDPizbsGlBPTGtsgFQLiAhAw49Iwa/H6EELO87l+5h5sXZr0M60YQsaPAY/KgvlSuAMWcUb/nAFVzCzWemukgAAgF8cFqWL23hksZiBq4ZeNRBXJvLYfjrGBZ8OIbBHC7HTTt/CvTVQGK1Y2QLlpUYikqH1eX3j5O+AuA28omAjbJTuX3nr1Elv1GX84olAfFbPBPn9mx6RDXhKONm7zu1Vl/yoDG3YkPnXyIkGN1HhuaQH4zMX4fClgt1753AJpVugBlzRsgdVR1DLZ5Vjuuf6ztrYgoY5w4NbcOMyD1Ik4V+RnDEXUFwZTSssorYmBkYVLLK+wUIOUHipOeWC/DQnJYqtI9cjk0RSfBc584DP7dD8nUg6m+IhftiVvptEfiUok7+oEMLBT1/Y3JMF/R6A/PjV6d/sephYXqKmIx9nEHfzwnNA3aMumILhE5tu2yBd+HpzQWDHCLBJeIIYDE9r7NFSYvYVXOgDDiuJCvUWuSie4LvaMjc7n0VW2t5odcZ+rp7hj3+NbFPrLeJQLAOtUWCHj/WYX+FUSr6Q4IQV3d7vfmb8K9igk/Fv3xl2ddQp1rPNPd9B5O0693bXBY33Bgfoq48SFaNGhkbR
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed49f56-217b-4099-3881-08db055d7c18
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 20:38:47.4647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tn1zH89GI00cY+TJsLHFaEN760Y0VpwDFzjZBQc7qjfyV5hOmmccHYluFf9hpFhRMoiRutQx4ApXu+RKu1ODbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4444
X-Proofpoint-GUID: L70HH1exq4NtbfboUq8dNzeJs7OJZ-5W
X-Proofpoint-ORIG-GUID: L70HH1exq4NtbfboUq8dNzeJs7OJZ-5W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_14,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 impostorscore=0 mlxlogscore=826 mlxscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302020183
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCBGZWIgMDIsIDIwMjMsIExpbnl1IFl1YW4gd3JvdGU6DQo+IA0KPiBoaSBUaGluaCwN
Cj4gDQo+IA0KPiBkbyB5b3UgcHJlZmVyIGJlbG93IGNoYW5nZSA/IHdpbGwgaXQgYmUgZ29vZCBm
b3IgYWxsIGNhc2VzID8NCj4gDQo+IA0KPiArc3RhdGljIHZvaWQgZHdjM19nYWRnZXRfdXBkYXRl
X2xpbmtfc3RhdGUoc3RydWN0IGR3YzMgKmR3YywNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgY29uc3Qgc3RydWN0IGR3YzNfZXZlbnRfZGV2dCAqZXZlbnQpDQo+ICt7DQo+ICvCoMKg
wqDCoMKgwqAgc3dpdGNoIChldmVudC0+dHlwZSkgew0KPiArwqDCoMKgwqDCoMKgIGNhc2UgRFdD
M19ERVZJQ0VfRVZFTlRfSElCRVJfUkVROg0KPiArwqDCoMKgwqDCoMKgIGNhc2UgRFdDM19ERVZJ
Q0VfRVZFTlRfTElOS19TVEFUVVNfQ0hBTkdFOg0KPiArwqDCoMKgwqDCoMKgIGNhc2UgRFdDM19E
RVZJQ0VfRVZFTlRfU1VTUEVORDoNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJl
YWs7DQo+ICvCoMKgwqDCoMKgwqAgZGVmYXVsdDoNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgZHdjLT5saW5rX3N0YXRlID0gZXZlbnQtPmV2ZW50X2luZm8gJiBEV0MzX0xJTktfU1RB
VEVfTUFTSzsNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7DQo+ICvCoMKg
wqDCoMKgwqAgfQ0KPiArfQ0KPiArDQo+IMKgc3RhdGljIHZvaWQgZHdjM19nYWRnZXRfaW50ZXJy
dXB0KHN0cnVjdCBkd2MzICpkd2MsDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBj
b25zdCBzdHJ1Y3QgZHdjM19ldmVudF9kZXZ0ICpldmVudCkNCj4gwqB7DQo+ICvCoMKgwqDCoMKg
wqAgZHdjM19nYWRnZXRfdXBkYXRlX2xpbmtfc3RhdGUoZHdjMywgZXZlbnQpOw0KPiArDQo+IMKg
wqDCoMKgwqDCoMKgIHN3aXRjaCAoZXZlbnQtPnR5cGUpDQo+IA0KPiANCg0KVGhpcyB3b3VsZCBi
cmVhayB0aGUgY2hlY2sgaW4gZHdjM19nYWRnZXRfc3VzcGVuZF9pbnRlcnJ1cHQoKS4gSG93ZXZl
ciwNCkknbSBhY3R1YWxseSBub3Qgc3VyZSB3aHkgd2UgaGFkIHRoYXQgY2hlY2sgaW4gdGhlIGJl
Z2lubmluZy4gSSBzdXBwb3NlDQpjZXJ0YWluIHNldHVwIG1heSB0cmlnZ2VyIHN1c3BlbmQgZXZl
bnQgbXVsdGlwbGUgdGltZSBjb25zZWN1dGl2ZWx5Pw0KDQpUaGFua3MsDQpUaGluaA==
