Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42502693590
	for <lists+stable@lfdr.de>; Sun, 12 Feb 2023 03:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjBLCJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Feb 2023 21:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBLCJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Feb 2023 21:09:15 -0500
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E980714484;
        Sat, 11 Feb 2023 18:09:14 -0800 (PST)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31BMUmbY020918;
        Sat, 11 Feb 2023 18:09:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=m75kHTJzjt0g3dBE3LVUfRq2Hv+EmmBGFOdgqaZnnck=;
 b=H2KTrG1MZ71ehGZisG5cUHwnh7IeIJeMa2/J9bEote/dgZDH0z58wTYYFLxAZn1IpxrL
 EG8Q0ztAbb7mhVs6YaRHeOsuiVsdC983Ys2AmeBwCI3BSGdNLMv0v/0sza15JDYU8x4f
 GhSxbW1Z7e3Pcm/D+VtV6YmzWoXrS0yu4yyO2wzGowDjJ3gZRbpxHpnxgWClvTAReZWr
 WEM4nflDvlgPac9MsPn2W8jcaQ37QQOkB4WYgItnMbh/kCSIxsK50mTh/AzWukp3Ph7r
 JPHOoA9gUEJnI++iI6uFGZpVhHf78NrrnfvEmELNAzoOTmsBDR+P4aR+rWJIbgbd2bZd 8w== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3npawtb4ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 11 Feb 2023 18:09:12 -0800
Received: from mailhost.synopsys.com (us03-mailhost1.synopsys.com [10.4.17.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C363140099;
        Sun, 12 Feb 2023 02:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1676167752; bh=m75kHTJzjt0g3dBE3LVUfRq2Hv+EmmBGFOdgqaZnnck=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=K5uhn3GzQLtWZ08U9lBoGM3i4ABhpgfV1H9nOE4/A5HypVf1pUkYDrNQqzojsTz7F
         4pupSjxljo2QL2co6EnrJIEegwUkOobuu4meBd/J4QgxDdtJZxuXzByM6hCU/f/fUl
         Vj2Qxwu4mDJDi8pV8RMjyHeRsO0zUaPmEp0mHxkMqU0w8XSElSbHe13A6sLBEVwYV1
         5fh8J07+dTQVgYgdSnAQxC8HFDAP3/dhT4A3SMzUwOmBHExnigaEgqYxK8CVyF3eM7
         PPObhxqnkBrtGXuM2jS+81dILcrIgcssUZ1UxCOjOSMA19s/MxkkKJ0kn9avKLmuh0
         67ZMnv1c8zmdw==
Received: from o365relay-in.synopsys.com (unknown [10.202.1.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 1DD47A0080;
        Sun, 12 Feb 2023 02:09:10 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id A6969A0060;
        Sun, 12 Feb 2023 02:09:09 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="ZWxzthF3";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqPFnEFzyhmwXcHWLtWoYkmhTqrR4VjEBWzr2wsa08w3T7KlOILvF2kEJ85yufNaA0QoqCYyjNH7sOPfPX9qBhaweZ32JWBNsuXvwpFJoe/NV9W501xigSdDmttIwTKGgdw2nqIzyeTaN3QrHZIpaJyD7WuioWtfqiDLJzIrH3ApCeKO6zxxC4Dt7BEQj2ISf/Oip6xJtlfO9EBruelJAqcZt9R0n+Q3MY7aj5ebQm9POYByXxrqHUDRjn/9g8v8yvfIrV9XoEuXcqgRzsoVHH3XGXjZyyWkTz9xFy0QszU1QcsbsKRu/7DMgrQe347hVYQQDY2xn7uM26SIZhM6mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m75kHTJzjt0g3dBE3LVUfRq2Hv+EmmBGFOdgqaZnnck=;
 b=OCz36VRIUnDghWWVERI1pvxWQIm81wCnNMUwJBdkmRw3gZkiDc3MDMlGcn2lID3ZCC1kOKISHullM/kOxEUN8eSr3q5xfQEiioE0zPh9eTdXW+KkXqmwIHO3pxfcIJHTjfSZNBozPzJ3H7wwrZ6HbngelndZa7iVZcaoGHd6givsFQqIpD2+rmX3jYDwL6GQ3A17sWk2LiJDkH6pUp/R8nL6Nvu+lqNTfuXe/PTb/5TvOYDxbxmjtfMbe6HuPqZDfyXHsy5Xtr2a6jm7NLhMN+LYEeKtJnhZMtI6HiP0vny2G1/rrmG/guwJHuUku6SGyoj1x09nFgqUsne2kglNyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m75kHTJzjt0g3dBE3LVUfRq2Hv+EmmBGFOdgqaZnnck=;
 b=ZWxzthF3dg3Rxc8sVmqVdJ33BM8403k3Zz0++SPFHg8H3PytA00H+Ei1eus7QBlmSsGk8fUYwaqQz7+v5gyahSazDrBstBp/1hwqOfbhxXmsAesMdoSwgwWQtTLNxm1YZYuIKLsoolhgMFjckg+xgiJXcUmQGvnsFqLTAahh4hc=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by CH3PR12MB7690.namprd12.prod.outlook.com (2603:10b6:610:14e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Sun, 12 Feb
 2023 02:09:06 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::6f3c:bd8e:8461:c28c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::6f3c:bd8e:8461:c28c%7]) with mapi id 15.20.6086.021; Sun, 12 Feb 2023
 02:09:06 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Linyu Yuan <quic_linyyuan@quicinc.com>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jack Pham <quic_jackp@quicinc.com>,
        Wesley Cheng <quic_wcheng@quicinc.com>,
        Elson Roy Serrao <quic_eserrao@quicinc.com>,
        Prashanth K <quic_prashk@quicinc.com>
Subject: Re: [PATCH] usb: dwc3: update link state when process wakeup
 interrupt
Thread-Topic: [PATCH] usb: dwc3: update link state when process wakeup
 interrupt
Thread-Index: AQHZNetg1e8bWR5O+UmEKJODDDA7p666dI4AgAC0WYCAADgqAIAAv8OAgAA33gCAACrGAIAOHqQA
Date:   Sun, 12 Feb 2023 02:09:05 +0000
Message-ID: <20230212020902.qxsha3fkvnftebhp@synopsys.com>
References: <1675221286-23833-1-git-send-email-quic_linyyuan@quicinc.com>
 <20230201190550.jozzrvwdi5lcwtbo@synopsys.com>
 <197a1446-9382-3d83-d26e-694e4d707679@quicinc.com>
 <d6e66c50-421d-f57e-fae3-1a4e14dce780@quicinc.com>
 <20230202203841.5vxxtejol3zyjjef@synopsys.com>
 <20230202235838.5d3a5lgdspahk6od@synopsys.com>
 <47a6e9cb-e07c-2296-c9f1-6c7f92abd670@quicinc.com>
In-Reply-To: <47a6e9cb-e07c-2296-c9f1-6c7f92abd670@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|CH3PR12MB7690:EE_
x-ms-office365-filtering-correlation-id: 373a811d-10e9-48f4-af16-08db0c9e1e7f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /a4YpBrEdragORtaiSIyWvCB1qRaufq/bYo60d05Rnyve61FwRqXPyy9jt7pPm/WsW7A74l9xMyE49pZ5SnhqhRJQJU4pO/JX8TJA7uCpmXep6eZC0rF9ejFbXI6sopU/sRJpPNZykBlbht35lEarV9N6E/6RIZd3a5kLhhJNReSqq+jdevqK03dedwSV+YfOgy5pffZEL6IQmAcfDmgkO07gxb4tW4DucmUdb6djFi6wAIv+AO3phb8ZZEMpnPIkY5To8hIBaOskIVogb4q2HYh/GP+3AGOKVQsaf2qsNT/9GdnxzLkLKpx11gfW988X+s+RsDEhPnQDNlqSWYMLSNS5qY9Tb7oR9VtAHR0uO7l21srVW+Ja/noo3OZ1oZBtd3acXHKgtbNnBqwmUhNRUASy861Y3c46+vMJphPHQvbQHKNs1SK2oYHGpsOMaEZDi0yq7FZBM/3KK7Ng6XXeVMOA9rYBro3voXICAq/fK0/mUS6C2RoIk9c99ZJ7s0//rBIcnn8FmRikAUkFZVxtf9meqw/4z8Zf8Hz5m+/Ugk7VCNyqxPnYg7lWwLS247TSQd9sM2N9HkOZoSyebi75KWVv6zExuMb7+afAWEnQUSnAO2iNXCaklEQwG/9OglBU+/99P+uNI3ZzwwUwvlz1Z6h8+Ac31x91MtqbJhW1UeTSRF8TYGPDqNbwVI4pT0M3NqADUDuy6+vEiM8wAkXiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199018)(83380400001)(15650500001)(122000001)(76116006)(316002)(54906003)(36756003)(66946007)(2906002)(5660300002)(66446008)(8676002)(66476007)(6916009)(4326008)(41300700001)(8936002)(64756008)(66556008)(2616005)(478600001)(6486002)(71200400001)(1076003)(26005)(186003)(6512007)(6506007)(38070700005)(66899018)(38100700002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bkwyaHhLMFFna3VFbmlPalkycXdPWFVKZUZXckh2eUpMdHBPOUpGbFpaSWlC?=
 =?utf-8?B?aEsvdnRqUjd1M0ZHVTd0QlYyU3FsMWdTcDNYR0hKWW5PRWhheFYySm5mQVZB?=
 =?utf-8?B?NGJ4d2l1ZXkyNUQ5TjhneVdGY09MbzI2NFFoYjZPOEIwYlBGUGFWWlk2QUVS?=
 =?utf-8?B?dTdxWDR1U3B5am5TMWowKzhvQkt1QVVpcnE4c3NqeU4vNVZyVVBCS0graDNV?=
 =?utf-8?B?MTV5UlFXb1RJdHp3RlVHa0MrMWtNZmtJR2NsRlIwWTF0VEM0bW1aZVFSTXJJ?=
 =?utf-8?B?SW4vRFlhZHhGS1FjN2hIVDBFTVhtL2ZDdDg5ZEp5REFmcW1OWW9PdnFKSDd3?=
 =?utf-8?B?SGZ6SHpNdmkreDBWajhTL2grVlhDQkhpQ0hjOWVCRmdlSVFrVEJBMnBqTU54?=
 =?utf-8?B?SWFzVFBTWWp3a0t6OVJTamJodyt6UnZWcmRyK1cvV1A2WmREQVpZS1h2RGVj?=
 =?utf-8?B?NlRIditJWUJ4OUh1UnZsZS9nQ0UySFc2bzVoWVVnc1Q3bHB6N1RmQysxQVJ6?=
 =?utf-8?B?dm1iaHFaUW8vVUdDUlBhVjBlUXl5bmlIbk9oYXgxTlZWRkFaelc4aVFDL2hv?=
 =?utf-8?B?Ymtod0lRSlpxdnlzYmVUak5URngxMnByZ2FvSEF3QnlNcnZvajdmQ1REMzd3?=
 =?utf-8?B?SHBES1V6a0VGRGJURDNDdUNIUEdEdmt6OVpnT3VxZkFyV2ZpdEs4eVZQR2Vp?=
 =?utf-8?B?N2RPaVVPcGlUNllZQ1JLMGJEbWcyOUJaeGc0L0xVd2Rtc2tlWU9oS050RStT?=
 =?utf-8?B?YUxucW9raS9na0l2MnplTjBRWXYxZG5BTVBIUGN6Sm9EcjR1QUsrNXBSQlZG?=
 =?utf-8?B?aWlQOVJONjd1em1NSThjcFFLVkZjTjVWbkdBTE03djFEUU9Cc0loWnNNSGdw?=
 =?utf-8?B?alVpZVVxTWNkYTF3NGlia3ZXdlRuenNrcllRNlNEVERuVnlQTmpLdWU1TjdK?=
 =?utf-8?B?c0YyODI0aGhmWUFjTHZ4UHhTUnJoSVVpYkxqMlFSUzg4cnk4RWVYUUp4YVlU?=
 =?utf-8?B?TzJZK1FqdDhZTHVJcldBaDlQZnNJdnMycGdONmhDVWJJN3ZjVW9DekduMnNE?=
 =?utf-8?B?RUZtdDRGOXlxdjZISFUvQUFqUk5JMmp5VTQ0Yld6UlY4UGF0U1J2VnhXRXdL?=
 =?utf-8?B?Q2lIcjdTbFY4aGVlTlpZbk5mbElwY0VEQU9rSjc5WFV5T1lIZ3RYTjU1YWlr?=
 =?utf-8?B?TDBFNXhFYUlzbXc4VzIzU3pKb2d4cXFVdlV5bTFqenExZ2hsSTE5bFU1eHpX?=
 =?utf-8?B?V2xCWnp0dUsxcGtBbDd5clpKKzBMNUNCZUFnQUdRdllzL1dpa3AzSjFIRTlL?=
 =?utf-8?B?WDE1OHJKbkw2bTV4clY2VDlhOWplY3VUTVhuN3B1REM0aWZYQ0U0b2YxcU9U?=
 =?utf-8?B?UkhmT0VXZmpEcmEvemUrWERMK1hTV1J0dXZ3RXI2MnNWNVdMTzJueTAzQlJz?=
 =?utf-8?B?eFIrd01MN29ETi80MG9jaXF3TEh2UWZ4VE5Kd2FBMisrS0xhMm5TUVpicVEv?=
 =?utf-8?B?clJ5c0hJdGJobVpoaXU0VnRiYm9mSzlNdUoxWUZkYm9RN0NydlZoclp6MXRJ?=
 =?utf-8?B?Y3pSUEk2UW9oNmsrQ3RVa1hjbTduV1BtV2NoN1Z4cFpFd1ViNERIRUNHQ0Mw?=
 =?utf-8?B?NTF4eVlnb2djRDJ2RkJ6ZkFFZ0VSZVFadnY3TzF6M01oUytGMXhaS2dVYmoz?=
 =?utf-8?B?RnRqcVhQMnhaQ3VWcHJvenR4bHZDdzZPSzIrbHhlUEhZTFF0VldRLzBMdXVt?=
 =?utf-8?B?YnNsdkV0NlY2QUI0dVM1VUlrT3JKWkg1ODNGdUdQeXozQWpORHY1S0V0YVIw?=
 =?utf-8?B?VlAzek5NUWZOd2JvdkJkVjBEc0VuMS9hOEp4L3dlN3VHc1NhbnpvRXBQSlhx?=
 =?utf-8?B?czYzc1Z6YzFCRXdrenRpQ3lqNGszRnFCN2pRdmtkY2MwY1BubDU2M2hFVkkw?=
 =?utf-8?B?cDF5OXBhMCtLTmFNSVZUSWx6NTFiNUh2SjN4R1hjbUJUaElSUWpSOUpSNHZG?=
 =?utf-8?B?Ym1vU0d1bGtQM3lrNytzeWRob25HYjkwcVFMcVk1Y25HRmZUQjFkNmpKdXpD?=
 =?utf-8?B?cExRaE0vMytibDc3ckpoN0x6cTM1WDNiWW1wMXBmZExINWQxRGpHd05pek5G?=
 =?utf-8?Q?O2drUerMTpNGSjHxLaA3MfZLr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <401319789649534E859B9FE64D2C74F7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SyLCr8U9qBgg8cG25BvZlT8e1CBlnhCl/6hM5hDIi58Y73l489wD5ATkpUCE5c+trApc4I+kz+QCClKg2OiIVaSjDDWcxnSJFm0kkt2TPHlanGADcpfqmwo+/JPB7R/rxLxqmlB9J3IR7GZLjK9iRDuZz2sVOdShNcyvyGWHpIMGaH2TUs+wRBQDzZRD28h0O9ehoFcKV+yVoOQ0LMW44/wzS7tcd/WUlb6BnRCXFjYbuM84vk1qAIgctkBlRnzDG7Vbu66mbaXlyV1/dAz6ynx5m3WJeVXMdsBf+xAk7OetAZfEmXqyK4ztjiTw7MLNU7wKUqaPBGwtnCcIBjc791wLsom/RpKivZVtRe3bsX8f4De7CPF068NDa9H90ARBCpU5R+7vcStpdOJI3bepDVxWS7unuOWZrKH0z28hDF28Yf1oPbEWi3MLTXeYc64nMaBNygz/C3Z5qEPGkDwHo/dVMRbeChETZxsa2XYetRvXfe344F8BVioatLjbzm/e55HnTEnPKJqWpwhmCUmv+oUc4oLIA4qg/EAzLVULnC0sMyITSo9abrY/e2dfVsw9lX7dPlpQlP/77N6tNSS0T8CQWQgP+l22bb2kEQi+1Eg0wdWv8F9D1Hwh13AnHEYYhXT730DpTFtEqqE8lcHubVsjipdU6VuEvcPJ6X1A8X4hcFy5Ee98HRBdCjo5ZIegourWnU1YQI349OSLzfd0f6mCLP/ErYgwHsh/RcS3V/rexxNWCw2xbQN0V3/ieERrISjXL+wkwcPcS1XfXVH51ur3c/tAfr/VcCNU2JU17+/tdGU2N0PsG9w4wejiePbmeHEWrw9NmJx5AX6lo/0vNbnDrXvPtxI67ndgS3OJGBkRu4KH8IRC8iAPCttf5JnlXfXRKBO9HUmxl7SrqBtx6w==
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 373a811d-10e9-48f4-af16-08db0c9e1e7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2023 02:09:05.8951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tZHo30157pEn4YOuearvrwd5ZHYl2NIcGbtDiamy2D09ji7WjeyQi2zm4cD/dvWVI5my7OqdB5dzjpH4bNfj3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7690
X-Proofpoint-ORIG-GUID: 821r_VgTnpyW-BVwgZbi-4ybJxdvrdA8
X-Proofpoint-GUID: 821r_VgTnpyW-BVwgZbi-4ybJxdvrdA8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-11_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 bulkscore=0 mlxlogscore=538 clxscore=1011 phishscore=0 adultscore=0
 impostorscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302120019
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCBGZWIgMDMsIDIwMjMsIExpbnl1IFl1YW4gd3JvdGU6DQo+ID4gDQo+ID4gUGVyaGFw
cyB3ZSBzaG91bGQgbm90IHVwZGF0ZSBkd2MtPmxpbmtfc3RhdGUgb3V0c2lkZSBvZiBsaW5rIHN0
YXRlDQo+ID4gY2hhbmdlIGV2ZW50LCBhbmQganVzdCB0cmFjayB3aGV0aGVyIHdlIGNhbGxlZCBn
YWRnZXRfZHJpdmVyLT5zdXNwZW5kKCkNCj4gPiB0byBjYWxsIHRoZSBjb3JyZXNwb25kIHJlc3Vt
ZSgpIG9uIHdha2V1cD8gSXQgY2FuIGJlIHRyYWNrZWQgd2l0aA0KPiA+IGR3Yy0+Z2FkZ2V0X2Ry
aXZlcl9pc19zdXNwZW5kZWQuDQo+IA0KPiANCj4gY291bGQgeW91IGhlbHAgcHJvdmlkZSBhIGNo
YW5nZSBmb3IgdGhpcyBpZGVhID8NCj4gDQo+IA0KDQpTb3JyeSBmb3IgdGhlIGRlbGF5IGluIHJl
c3BvbnNlLiBJIHdhcyBob3BpbmcgdG8gYmUgYWJsZSB0byBhbGxvY2F0ZQ0Kc29tZSB0aW1lIHRv
IHdyaXRlIGFuIGV4cGVyaW1lbnRhbCBwYXRjaCBmb3IgdGhpcywgYnV0IGl0IGxvb2tzIGxpa2Ug
aXQNCm1heSB0YWtlIHNvbWUgbW9yZSB0aW1lLiBUaGUgaWRlYSBpcyB0byBzZXBhcmF0ZSB0aGUg
dXNlIG9mDQpkd2MtPmxpbmtfc3RhdGUgZm9yIGl0cyBvd24gcHVycG9zZSBhbmQgdHJhY2sgc3Vz
cGVuZC9yZXN1bWUgc2VwYXJhdGVseQ0KYXMgYSB0b2dnbGUgZmxhZyBvbmx5LiBTbyB0aGF0IHdl
IHdvbid0IHJlcGVhdCBnYWRnZXQgZHJpdmVyIHN1c3BlbmQoKQ0Kb3Igd2FrZXVwKCkgb3BlcmF0
aW9ucy4NCg0KSWRlYWxseSB3ZSBkb24ndCBldmVuIG5lZWQgdG8gZG8gdGhpcy4gTXkgY29uY2Vy
biBpcyB0aGlzIGNoZWNrIGluDQpkd2MzX2dhZGdldF9zdXNwZW5kX2ludGVycnVwdCgpOg0KCWlm
IChkd2MtPmxpbmtfc3RhdGUgIT0gbmV4dCAmJiBuZXh0ID09IERXQzNfTElOS19TVEFURV9VMykN
Cg0KVGhpcyB3YXMgZG9uZSA3IHllYXJzIGFnbyB3aXRoIGxpdHRsZSBpbmZvIG9uIHdoeSBpdCB3
YXMgaGFuZGxlZCB0aGF0DQp3YXkgaW4gdGhlIGNvbW1pdC4gTXkgc3VzcGljaW9uIGlzIHRoZSBz
ZXR1cCBmcm9tIEJhb2xpbiBtYXkgZGlzYWJsZWQNCmxpbmsgc3RhdGUgY2hhbmdlIGV2ZW50IGFs
c28sIHdoaWNoIHdvdWxkIHJlcXVpcmUgdGhpcyBjaGVjayB0bw0KZGV0ZXJtaW5lIGlmIGl0IGhh
ZCB0b2dnbGVkIChob3dldmVyIGl0J3Mgbm90IGEgZ29vZCBjaGVjayBhcyB5b3UncmUNCndvcmtp
bmcgdG8gZml4IGl0IG5vdykuDQoNCkkgZG9uJ3QgZXhwZWN0IHRoaXMgZml4IHRvIGJlIGJpZy4N
Cg0KVGhhbmtzLA0KVGhpbmg=
