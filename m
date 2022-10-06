Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CC05F5E9F
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 04:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiJFCMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 22:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiJFCMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 22:12:32 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD142CCBC;
        Wed,  5 Oct 2022 19:12:32 -0700 (PDT)
Received: from pps.filterd (m0297266.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295HCihW024334;
        Wed, 5 Oct 2022 19:12:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=LY88+k/0WFToL3n40za9yGgjPgMdKj0iGM3KKIl3+yk=;
 b=BR5QH3/eWcbKKhPJwcDRFxDbV3s7soDW+LZqfzZdLLQFnY2/POF4ERU9IPAu6RyWWslX
 ZAgT9Q1P21LYSCFKqvsR4v3h/LwbDwKobKSqThIIYSu3UnrAWY0ENgp8rpfd00TxgLts
 Ie2lVy+dgTkQOaMup7s1ijNH9sTheHTawC+i8YtLkzNDpqPt3M3hgQVbaKjzygu4wFVs
 /gLt2PgwepB1MgJbGjmfZpa8gZO8KXEA8+LIKACrN9Ul3sNQPSAfbKna+Ly4UYs8wIV7
 j2Y8hMMU7Is3RX6YCAZU7WU+2hRNanwZfGRQIFEIhLbA2dwau494Tz8lfJ9oPGU6en3X Vg== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3k04h7dgkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 19:12:25 -0700
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3953AC0845;
        Thu,  6 Oct 2022 02:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1665022345; bh=LY88+k/0WFToL3n40za9yGgjPgMdKj0iGM3KKIl3+yk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=iaAc/gebPZhEADR4LM1gZbhG/FCPbL+VLICNgvC/xN2px0MTOIONDoMtaIaZ45xgQ
         Jgzt5lyvHB+e+UsHHT9oPSKkBKu8vLlOmnl91ak6HWUqP67EAZ0uOhIMuSl1R7ayZ5
         WVxlkfakO9cVkPoBz+vgrsw22gWApjA3wlD7dqcCoZKBpkHbye7w82Mc+lq/P0WwBr
         //vpDPzC23nqvW9dTldN9vfJRJbFkvSgOys8AMcxI+BUhYj9nmG2G6H5EHVfghTZl7
         1zho3mERTT+i3/Dvq3d6bgpkgMR/Hqu5THrIJ/HqF3gE9IC90e4iV9Nl2bj6huGHe7
         3PtJwx9T2Iijg==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 545EFA0071;
        Thu,  6 Oct 2022 02:12:23 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id DEF3180083;
        Thu,  6 Oct 2022 02:12:22 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="vJdlm42u";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGy8vwH/2YadE5Oy8i+qlutbRE+xWXxiPc+NXjpnSq1IyBZcWLuw747RjoxcSTItZx5WU73LRBXVEwgxjSiLF0O7KlFNxHoeBcU8BvjG6VxLC6WuSL7sbmvkQTtXeIC2/mJQEGkxh0shTmSv8tP13whZYEg5IbQLm76lwWAPZ+FN9NBvGs8ADVRe1AQqyhxlQ4hx6SR2BSjfs/W5qCvwjeCEErPMMD+epOJzP7YF+K6PpDmGK3NEECLvUBieoLzqzMGhnW+qieG3kOchnur0hsab2Br0cn45dUXS179FKVy9NYKFtaJxyhHECO45iaL062yViz+fRL0vxsMhFExr2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LY88+k/0WFToL3n40za9yGgjPgMdKj0iGM3KKIl3+yk=;
 b=QjKqkZmfTKnV5w96NY0y0GvysL1xpcd27ePqkdTHlE6Ym+40E3rwYZ6dpRikJ4D6Bou81XP0NT1+ytKs78YSKL2xJmqIW2wrOWdr4hiRGRrUmHN6fFbw08pGAR79V7gU9ZXRE4TubXU4thdlnUAiL8NxRWoZpIiReD65X0wLCBn1W1621rLwGa9SBgR0qZEVgBBqvybDEBG1kBdlQxxU5NRgdxqIENPesy7v/xoxOJJcTFm9kf7fBS6mkXwIsfkVBBQhnc6NTP2RzgKuqBgfx2n+XmzlSd8NdGGcaXqeD33id0QxjTp+JrENl0aDmQYMa/CdFU/1yjJbzsJtk+mrkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LY88+k/0WFToL3n40za9yGgjPgMdKj0iGM3KKIl3+yk=;
 b=vJdlm42uFlK79YJyWccdqVbR6Tpmnf6xU82iirIjruFDaJZpnuY4kA405muphz3YIf/PO3Na4lAcgfRYxzTOJutnpsuHMWQ0/wHI+Rs/s3ayA59pvdr768wIgl3uIH7NNbcjK4cQ7KbxAbqB07+mnqKreCm8OgpFuo8cyqiZvNw=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BY5PR12MB4194.namprd12.prod.outlook.com (2603:10b6:a03:210::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Thu, 6 Oct
 2022 02:12:20 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.031; Thu, 6 Oct 2022
 02:12:20 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Ferry Toth <fntoth@gmail.com>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Thread-Topic: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Thread-Index: AQHY0omsjm4tTlL0CEmkY916+rpAAK39QTUAgACwSgCAALRxgIAAdL8AgABe9QCAATNWAA==
Date:   Thu, 6 Oct 2022 02:12:20 +0000
Message-ID: <20221006021204.hz7iteao65dgsev6@synopsys.com>
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
 <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
 <20221003215734.7l3cnb2zy57nrxkk@synopsys.com>
 <YzvusOI89ju9e5+0@smile.fi.intel.com>
 <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com>
 <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
 <2886b82d-a1f6-d288-e8d1-edae54046b4f@gmail.com>
In-Reply-To: <2886b82d-a1f6-d288-e8d1-edae54046b4f@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|BY5PR12MB4194:EE_
x-ms-office365-filtering-correlation-id: f4c68566-73b0-4d4f-7b12-08daa7403309
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rCgc6r+TeJQzEFRBx22Ly26y1wz11v4XTi4iZNAiO/jHb0YCPbOkHgET6g3OXDD4jfKveJOrKNnFE+OQbiWd04JauGji9dwwP67MqZG8a4hbaBgYobMgU21rWahj2tFfTGyGeQ7+WvQAMVz0eS/zfo+40gEC709ajRuDbsWB5+4jKgoIcBsbhhSCPAA9J+RgFEsJGzs7R/EOiGR47PpWKxWtktIguZQKqkWuLLPxfed8qpK1a1YycO1F3AviZ/v2eWgyo+coxrvVMwJ8UOz36v4/8VULhpW9pPZcEDHwgwcZJaPzh2B21dIcniu3PfumX1TcIV3kJ2saRfNKJTovtBz0M+w6N1UsiFlSirlponVZJyUdn7vpOBULA65WiSki0ENuleQ5tBnPqVL/FWsCvbsxTmN7pgmZAe/FmkGG04nUUNf3crRyB0xGx7R6Qcdz+F1+Kc1E7sSFittO76oQ6MrpRNZ0GwqtT2BimHcoSbJo6GMeazh+0EIMsvZuu9ZnKhU9uB+6IgoRmU7txKaN4g907iGlNQKgGUjohKeSGfzpq/UrWQF0dpVTg0YNE2tbAGlsPF9kbYt0NL/kCPmjAZaMzSP6l0oWebMnd9uwdCwu4qbFZnTAul1BdGdZrRZJu2p+xUpy/zMvvF/hg89AzFr3l1Z3XJZU+9Ov8Hlk98WOfZRYmQFt58XiBVnhbJ5lFOBpethQ/A+tzb+lAIWuUbcEYEu+4xKW5hR/WD3+BuQzMIHQcodHwQLZ6ekwv4vIPYenRD013b2F1h+1idSOHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(39850400004)(366004)(451199015)(86362001)(38070700005)(66556008)(64756008)(8676002)(66476007)(36756003)(6916009)(76116006)(6486002)(4326008)(54906003)(41300700001)(83380400001)(2906002)(8936002)(5660300002)(478600001)(2616005)(1076003)(26005)(186003)(71200400001)(6512007)(38100700002)(6506007)(66446008)(122000001)(66946007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmNSN0JiNU4rbTB6bGpIUlJOZmE3aXA1Unc1OVI5cHdTZVJtUjBJbWRtUWRo?=
 =?utf-8?B?Z0hUdmtHYlNGU0JDUmRETkhCQWlxRDQ1d2ovUEhVZHo3SDBlcmUzWlZqOEhq?=
 =?utf-8?B?VjZUbDJLVHpHSEpNdksvK2p4MlJPTWdUeFFtT2hrTTFmbEpEbUdZMUptcGNH?=
 =?utf-8?B?STdkOXpITEN6M0xnbDRrbU1GV3JYaFFXT0ZRcUhQTFpiMWoyajRGZkJ4Nmdj?=
 =?utf-8?B?MkdIcHI3cXJRZkNCQ21USU4xRFB4VVVjNzdYb3p6Mlc4T1BZVVpxcjBIZWZO?=
 =?utf-8?B?aHM5UHVmeFphcE9XL3ZsRHgwNGZtYkFLZ0xUMy9YeFRxd25UYWxRNzQzM3ZT?=
 =?utf-8?B?Qzk4aVB2dTZ3aERTM29DOHZOd1RXY3NVVEFhbDcwWG8xbVJHYVg3T05HUjdp?=
 =?utf-8?B?OThwWGpvU3J3VmpWeXllWlNyQy85MndpTTZDOVlOMzF6UXdtZEdYdWlSOE5n?=
 =?utf-8?B?bk4wMnA2RFdmaTBaWGZrVVdUYS93bDhZUTBRczk5Rml3bFE1SWVBY2JjelEv?=
 =?utf-8?B?V2t4WVBaR1N2Smw1V0w2ekxrOWVjNVh0b3ZvWUxMZzBTTjJUQ1M1NzY3UTJv?=
 =?utf-8?B?dGxUQ1pjdkNzSWYrWmRGY296a2s1WUl6M2VYWHpJUXRvbWdZWGExeFF5bnhu?=
 =?utf-8?B?VlVFTmNINUNQWkpzNmN5a0RFckE1T0hKUjVTZGpvZUk5UGFLaEdWZE1EVnli?=
 =?utf-8?B?RmxVVEdPbXJIaC9XeVdvUEhZT2haZGJ0NDl1MlhuN05COTVPc0dGS1BwT2x0?=
 =?utf-8?B?UVRqRDBENm1NbHdTb3lqTnE4UXFPMUdjblhJQithNm4zbjVTeHRxenlpMmFh?=
 =?utf-8?B?clBuN1hkVEpXZHRROFZpS2owbExTcFNjOHhtbGNWcmtjRGhoT04vSzNRNnBp?=
 =?utf-8?B?U0lGUE1UK3R6SUJpWGtBY1Q3ZFZzOHBRNFJpTm5tT2lsVXJ4NGhnZUxFRFdq?=
 =?utf-8?B?TWRhZjRzaS9xZkZxa3BIck9MUWhua1hDWmU0NzFIOEgrSXE2VmtvU2pnMU92?=
 =?utf-8?B?RnlSZjJjUTl0b1BUSWxpUFNIaXg2VFI2UXBtYzBjK2ZHL2Z0RHVZV1NLeUQz?=
 =?utf-8?B?M0lZNzd5VjZmTGhGWkdDN01xaXQ3RDJ1RnNPbVZ1cUxmNVJ0blVZNkQvdkgr?=
 =?utf-8?B?cHdhakxQUFNrNVNkN0lOR1BLbnJtZjIwY2YyM09tNGtNblNUMk1tSTlJWjdF?=
 =?utf-8?B?TExHM1BIeVlaQVJka2dibWdXRStMOGtxVUlNeDArdXRnZi8xUTF1ZnRla0ww?=
 =?utf-8?B?cFR0Qm91elB0dERuYWFIUVAxSEZlSkVDVGpMdExvKzQzUkJvWVQvK0s3dFc2?=
 =?utf-8?B?a1BzVkk1QmxTMVZYVjhRRDY0V2t6RWJUTUdrQnJVV29kNmVlWVBzZEowaHhY?=
 =?utf-8?B?WXFnZDZ1YUZlVHB1NnVHZFlKWFUzeXJCZkRyK2xIYUg3UzhiTG5mTUYwdGRu?=
 =?utf-8?B?c0huNUJMWVVaZ0lnT2FzbWo3RzZ6QUpWUEs5cmFiekJ0ODgzdmNLL2ZPeElK?=
 =?utf-8?B?WkpMUjRieWtTTnlkeWdCNmZtUVRYZ1d6YjdVdVowZGhYV0JjTnFSUG5SSXN6?=
 =?utf-8?B?cTUrbDN6b2ZONm9SeW1DRkFSc2pKMVZ1OHBOMGtvUkJ6TldyTVViTWs5czA5?=
 =?utf-8?B?b3BLWXRqSEQvaGRRMk0zUTFlZXAzMSs5RFBsb3gxS2pyK0JHMStRVFVFVWhl?=
 =?utf-8?B?dXkrWEMwVTAyd3RRY2QxUHJJd255a3JxbmRyRVMxckNldkJJbHAvN3VZZDlD?=
 =?utf-8?B?aHBSMnExRGNPOEpvclZiNDZKb1FxdjNmK2trL2dRemtnblFYa2NRMzl6VGpH?=
 =?utf-8?B?dmJITW1JOFpvNkJQZndBT2hSbVBmUVR6aWpML3dBa2RxUGpwNjREQTlUTXBy?=
 =?utf-8?B?eHJBOURWWFc5WlZRRUJkS1pTMG5SUUxQVzBteXN5eXR0M0lickY3am9iUUlF?=
 =?utf-8?B?YzVqUFpwWG16NlEwYlpTaFl0OFphVlp5dUk4eGpiQXBTVXcxajRUWDdsZzRk?=
 =?utf-8?B?QVEyOU83dG9md3lyRXpSaEZEODY1eGNkWDRTckt0Vy9XcWJld3VGdlo3ckNX?=
 =?utf-8?B?a2R2Y1ZvdEhqMDdiZm12cjM2cnRZUGNRczkzVXh5T1JzakJMbGNjTEtpbFRz?=
 =?utf-8?Q?/mNr/dBQfaC2mGp7LN31Ar66R?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8014FAEA345DC4D96372CB199424A16@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Q1JUWVltYWNsRUsvTXQ0aUhlSkFpbCtxSmFzWXZnZUJaVDNXRkhZY01Fa2pk?=
 =?utf-8?B?cXRTSkt0S2ptZ2xLRWV0UHNBcTdPUHorYUFSMnQ2ZnFzdStSUEd6WXM5S0wv?=
 =?utf-8?B?VmpXOFlJRUYzS3JzM3EwWWdSbW1BNHFVZWQ5ZUlrU2djZlE5OENZQmNHK3Jr?=
 =?utf-8?B?QS9Gc3F2QlVWdjVxQ1JCdWZ6NlFRcGlKNkVZL0dvYUxxSld5L0pUd3ZydFox?=
 =?utf-8?B?a2VSRFFmZEFVOERzbVRlY2owVSt5dXk3RlJ5Rm52dGoySUdLMnUyVmJnQmpl?=
 =?utf-8?B?OW1ySVlyUnY0d25EZ3ZNZUN5Y09kemtTMmpJTjh5ZnJXeDUyUEc4bWZRWGtt?=
 =?utf-8?B?Ni9RbGRJdW9KV0dQTVJtVW5tWGcvbVc3S2hsbklKZnhTMmNKSGtxUmhsN0Vi?=
 =?utf-8?B?bTRZbkFHTlhOVnpDeFd6b2lZSWlzMXU1MjV6cWZhMldBWVQ5OG1xbU80TFh1?=
 =?utf-8?B?V3pYRk1TL2xzTlZGTTU2K3B1bmx6ZFFJRkVqM2YxeG1BajVvNTdYRGNsajlQ?=
 =?utf-8?B?K2MyaDlHZUk5bXZJMjBkWFpTSldXNDJTMGNuK3JvZHpJZ29tWU9naDN2aUxJ?=
 =?utf-8?B?dzIrZlFnNy9tWGNhWnpLOXQyVXBUcmpDNHcxVFVFOVdmQUpYWVFrM0JCd0FE?=
 =?utf-8?B?aEJBdkRJeVFHbThnV0lmaWNQNHBFODd0cFZSMGRXMzU1VWdhcWx4a3pPTU9i?=
 =?utf-8?B?b1ZNM3MzOFRBcGtzOEdhRHhPazBNRzBCMDFZYzJjaEJFNGJId1pwWjlPN0I4?=
 =?utf-8?B?Vm1rZm5tYm1pNjRRNmlNTzAxVFJBY0d2REpKbm8wNFM1VldsSUV2QTlBY0dn?=
 =?utf-8?B?cE5FMFZUa0xWeWhtSm5aVmRiVHZlYm9LY3JlUkpEWkJueTYrM3RHWi83bmFB?=
 =?utf-8?B?ZityTjVHUldYZTg3UFlkL1JGMVlBanZFSGUvcmlEUGdGWTE4RVB6QWk2cWRu?=
 =?utf-8?B?NWJtYmVIbFp5WGNYV3pnZnh4amdBbFgvbTR6STdDbHlQdGRKeWxycFd4RDFY?=
 =?utf-8?B?N21RVUd4aE5CS3h4Q0VQWlRhUnlTTWxla0Uycmtqb2djZHZNcDZVWkVzUU9G?=
 =?utf-8?B?Qmc2RUlLK1RWZWRrbUVUVGV6ODhvMm9TeXpwYTYzYlE3Yy9IQkd4RWpmVUFy?=
 =?utf-8?B?WEFjUjB5M2IzcGVzVDNYZ3RRY1dqdHZteWFIWm4wNE5CNXNJcjJ4S2xTVlVI?=
 =?utf-8?B?NTlEbTUxOHdrSitja0Ftc3p6WXZaSmtra2JTUk5DRTZnRVVzNWF1MDlKTVdk?=
 =?utf-8?B?M002Zmd0K3FteDlWQmUyakV2WWlDSTY5QllOQVhaK0QwdFZnYUx4YkZadnlj?=
 =?utf-8?B?TFpGS0pIS3RNRDRjeVJsSFlQYlpPYWJCUTd4b25mT3ZicGhFaFlFZ2ZXdXc4?=
 =?utf-8?B?QlI2TktVcitIc0dieURDajZHYVBPYURaZTZWZWxxM0VnVGpDdUd4dUdaTHNE?=
 =?utf-8?Q?IlexjzKp?=
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4c68566-73b0-4d4f-7b12-08daa7403309
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2022 02:12:20.2038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qi5M3piZlUCAKHhG92AW90gJ3jGdTKh2HwBcSW3Rx1QNFcaJUdS3fjw0iOhjOwCUnBhxLTwmh+R0G8WeZswkiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4194
X-Proofpoint-ORIG-GUID: CMyXZL4Fq80W7s4UkztknYiR8PQwvIhN
X-Proofpoint-GUID: CMyXZL4Fq80W7s4UkztknYiR8PQwvIhN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_05,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 adultscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=633 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210060012
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCBPY3QgMDUsIDIwMjIsIEZlcnJ5IFRvdGggd3JvdGU6DQo+IEhpLA0KPiANCj4gICAg
IFRoYW5rcyENCj4gDQo+ICAgICBEb2VzIHRoZSBmYWlsdXJlIG9ubHkgaGFwcGVuIHRoZSBmaXJz
dCB0aW1lIGhvc3QgaXMgaW5pdGlhbGl6ZWQ/IE9yIGNhbg0KPiAgICAgaXQgcmVjb3ZlciBhZnRl
ciBzd2l0Y2hpbmcgdG8gZGV2aWNlIHRoZW4gYmFjayB0byBob3N0IG1vZGU/DQo+IA0KPiBJIGNh
biBzd2l0Y2ggYmFjayBhbmQgZm9ydGggYW5kIGRldmljZSBtb2RlIHdvcmtzIGVhY2ggdGltZSwg
aG9zdCBtb2RlIHJlbWFpbnMNCj4gZGVhZC4NCg0KT2suDQoNCj4gDQo+ICAgICBQcm9iYWJseSB0
aGUgZmFpbHVyZSBoYXBwZW5zIGlmIHNvbWUgc3RlcChzKSBpbiBkd2MzX2NvcmVfaW5pdCgpIGhh
c24ndA0KPiAgICAgY29tcGxldGVkLg0KPiANCj4gICAgIHR1c2IxMjEwIGlzIGEgcGh5IGRyaXZl
ciByaWdodD8gVGhlIGlzc3VlIGlzIHByb2JhYmx5IGJlY2F1c2Ugd2UgZGlkbid0DQo+ICAgICBp
bml0aWFsaXplIHRoZSBwaHkgeWV0LiBTbywgSSBzdXNwZWN0IHBsYWNpbmcgZHdjM19nZXRfZXh0
Y29uKCkgYWZ0ZXINCj4gICAgIGluaXRpYWxpemluZyB0aGUgcGh5IHdpbGwgcHJvYmFibHkgc29s
dmUgdGhlIGRlcGVuZGVuY3kgcHJvYmxlbS4NCj4gDQo+ICAgICBZb3UgY2FuIHRyeSBzb21ldGhp
bmcgZm9yIHlvdXJzZWxmIG9yIEkgY2FuIHByb3ZpZGUgc29tZXRoaW5nIHRvIHRlc3QNCj4gICAg
IGxhdGVyIGlmIHlvdSBkb24ndCBtaW5kIChtYXliZSBuZXh0IHdlZWsgaWYgaXQncyBvaykuDQo+
IA0KPiBZZXMsIHRoZSBjb2RlIG1vdmUgSSBtZW50aW9uZWQgYWJvdmUgIm1vdmVzIGR3YzNfZ2V0
X2V4dGNvbigpIHVudGlsIGFmdGVyDQo+IGR3YzNfY29yZV9pbml0KCkgYnV0IGp1c3QgYmVmb3Jl
IGR3YzNfY29yZV9pbml0X21vZGUoKS4gQUZBSVUgaW5pdGlhbGx5DQo+IGR3YzNfZ2V0X2V4dGNv
bigpIHdhcyBjYWxsZWQgZnJvbSB3aXRoaW4gZHdjM19jb3JlX2luaXRfbW9kZSgpIGJ1dCBvbmx5
IGZvcg0KPiBjYXNlIFVTQl9EUl9NT0RFX09URy4gU28gd2l0aCB0aGlzIGNoYW5nZSBvcmRlciBv
ZiBldmVudHMgaXMgbW9yZSBvciBsZXNzDQo+IHVuY2hhbmdlZCIgc29sdmVzIHRoZSBpc3N1ZS4N
Cj4gDQoNCkkgc2F3IHRoZSBleHBlcmltZW50IHlvdSBkaWQgZnJvbSB0aGUgbGluayB5b3UgcHJv
dmlkZWQuIFdlIHdhbnQgdG8gYWxzbw0KY29uZmlybSBleGFjdGx5IHdoaWNoIHN0ZXAgaW4gZHdj
M19jb3JlX2luaXQoKSB3YXMgbmVlZGVkLg0KDQpUaGFua3MsDQpUaGluaA==
