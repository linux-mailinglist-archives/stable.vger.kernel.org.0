Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4BA6BF0AF
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 19:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjCQS2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 14:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjCQS2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 14:28:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF37D6A46
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 11:28:37 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32HHuDMv032622;
        Fri, 17 Mar 2023 18:28:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=MCYZktH82Y8i7tdLCM935mGLeUE4+nU867AFvpL85cY=;
 b=ah2CABDIrGoxOGp4vWuq3V7QQAJo7hPZcggL3l7JXeNb0mrwKClVthJPyQGS0JzvwX6z
 eKB16zsADmeMAtIJt74dl/aujG5/v7TNaamn1JfkOASVaMrO0Lb1od5q6SyLq5EKlPj/
 2HJ9xOVJA4Cx8qVzaDjW57Nb4CEt+oiC6Exxej+DuItVWYZPTj5+LrhBwyPsZE25yI1F
 c3PVKXxPOYB22lkt4K2PJnGPDWOKf7BRsT9QFTOkVVIAzRuM+DenC5gfYdq8zGkLUcNI
 8yxW5hVIyyxQIts2LPk+ejEQoAj09IBX9atotCQaxEJQuOwdmz5ujU65BptkxE9F+axX cQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs29veuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 18:28:14 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32HHGpZC001170;
        Fri, 17 Mar 2023 18:28:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pbqq7328n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 18:28:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIM47RFsaWRssRlmNjTSoHJAqz69cnEJSgHHbqDWkTcj7K+rEr8R2Q90Rf4dBLW1Zz1lSeGuCxZRguI0TnsvrSYqitAOYIhFWQGr4QfHuxEldOIpU3TVxh9e9QpGqpp7jM/KVVAQ6GLoHRV2bj/mXf3NXW5m7v7R2CJcK6WpNcBumGWql8zLnSbdh5U9li/0JX79lGqaWTSbL/k42FTW6TsQQn0wpxc6dXF3WffLluRlTQNeUlZhXk8y2lhaBc0m5eMcfyU8GWUmrFZphve0ZA4Gwkj+pTqx8DxaxiJFFfRySrbE2pib2ba+AkckOIxf0lajFT7DPK/NAnoNmMobYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MCYZktH82Y8i7tdLCM935mGLeUE4+nU867AFvpL85cY=;
 b=jTSka4xNnLAFonUqg5aviLsQkbeo02tQtGO79bbMoFojcx696ZcSNh2W9rcJzOsC5K4vzcnmaZVizj2QGlzpfQiIvLlGgG3VsPHHm1ZkqJdKzDe3YfEgnzuLzjpqPGnsOGbus/UmSWKFtqN0a+9FRjCbWjPc6XVLLViz9b+X4QtK2cPgmPK05eFqE3E7UWDSXHQRBHnGYr3JLUHc20qt0dUHjE3XJ+cimn4ZtRm7QG6vAsoR9Z4YjgTHQLlI6JKrAKvZQVNRqRroLx0YPQvzevHeiY5mvQIIleOaTpnhHWyPQyQ0Z7fRaya3TAnWMkUAAi9iXY+GOzO49lUsN0a1cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCYZktH82Y8i7tdLCM935mGLeUE4+nU867AFvpL85cY=;
 b=d4GxkxixvBlp9XJPChc6MhOyF+A9A0R75CQcrk1VlxEAPHNeq3W9UKQ5UcWCBfVc8UVVtVXtbrAlDT4OxEzRi5L+pEABXPViiVjSE95PHV+Id1gL3B4MjcZuvc3o57dGmHbeEgNJlogvjrnvUhpi3n0JvAYWDHFsK94E8jilPNc=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by MW4PR10MB6679.namprd10.prod.outlook.com (2603:10b6:303:227::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 18:28:10 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 18:28:10 +0000
Date:   Fri, 17 Mar 2023 12:28:06 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 084/357] treewide: Replace DECLARE_TASKLET() with
 DECLARE_TASKLET_OLD()
Message-ID: <20230317182806.owvwdor6qpzp6tve@oracle.com>
References: <20230310133733.973883071@linuxfoundation.org>
 <20230310133737.692796889@linuxfoundation.org>
Content-Type: multipart/mixed; boundary="jchigfkk6fszsaoy"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230310133737.692796889@linuxfoundation.org>
X-ClientProxiedBy: SN7PR04CA0036.namprd04.prod.outlook.com
 (2603:10b6:806:120::11) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|MW4PR10MB6679:EE_
X-MS-Office365-Filtering-Correlation-Id: 73adb988-b707-48c6-e67a-08db27155c9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q7plxh+zMpLmVhpOHJyykAIb1Uqfec/gizenl1zNgSksvfuaV4R1EP3MnL747KsB621URj9Qo77mtCQ3Xr+lY6SNWoTJWxueU25fgRPYoVIqZ6wFF6LcioOvAX4QCL1R+SuPD/QntEmC2nY5ZvirNQh1rHR4gs4QeJXVXrd1EVwTmEiLY6IHRcGtg3jgs5B+vye+QhfP8mICYIAbmSg9+8Fk6ReQ37fKCJCX10rzwbMKyZl+juOmvpeHUPU3fPZSzJaODU9CQQ4zOhW3ETzaDi2dKhrRBQLujvtRWkLQfNiS4mVghaCsJjDvlsHHKTD/+yY55aJk6s+QC0XLNVtaFR96IvnfyIXCvTqK/sEvLV1nfSY0pFZKFI+eUobdunyIcb54Y0Ky8nX651PZ30JdPWbP6JBA+pCyPCBLHrs6NOOKxVQDUsvU7iqO3434/BFwyApn30URlU6cnpVpKzd6yiAA/C9hDi9nZSnRWS2IKdpOdyXtzQqDeqiLCq5RLp/fLP54FP20lN22vtWKAI+23W29+A/h1iBrO/reS5JsRn8HvnSm68C5+pXQJ+UR8iyiw+LpmYImcqnWaSsD/1Ih4w5kzfoKLw9Oq1Ig2FSI0qwPH4tN+9Sp7fJXw/6BpZYznOOXnp0ZXWuuVqpujkQzkQF9E4Rm9O06+3NWD0fOE59IbJdby6JcuKwMkdtMWI5o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(366004)(396003)(376002)(136003)(451199018)(41300700001)(8936002)(5660300002)(2906002)(44832011)(86362001)(235185007)(36756003)(38100700002)(478600001)(8676002)(6916009)(966005)(6666004)(6486002)(66556008)(66946007)(66476007)(6512007)(21490400003)(316002)(6506007)(54906003)(83380400001)(44144004)(2616005)(26005)(1076003)(186003)(33964004)(4326008)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjdsNTBCQjRqa01lanh4czVkTUJCdGZWZHhkWkYyZHh3NEMzWFVWUnNFMWYv?=
 =?utf-8?B?YmlSbHNDMnJtaUVzU2tCNjNZa1JBN0pMMUNkT21sK0hrNk50b3FFdFpNYVlV?=
 =?utf-8?B?bVBBYmRiMlFmNHM1Z2RGWnFwNityemZOdm9mVGphbDBhN21xWTlGOVZuYldY?=
 =?utf-8?B?THRjNTk5cUI5STlQdHNzOHFwbXBMYm5BOGg3WGpKTDR5WGtsNDZkWUxacUhi?=
 =?utf-8?B?OXFkRVhobWYwbUExKzZYVHA3VGd3VUJEZFhZTTBrd01qdE94SlVMdkFDT2du?=
 =?utf-8?B?czA3MUhBTmJtR0RpV1BJUjI5NFRIb3VIT0hmcUVGMlArOWI3RkswMS9VK29l?=
 =?utf-8?B?Q2thMXJBWlBCT25tS01pVGFwRjREdDYzdExkcXhkVjQ5OGs1eGk2UkRYZ0JF?=
 =?utf-8?B?KytIczlscHhRVTc5Qm5mTTZ3UWR1NUwzSG0yNjhGR05ZWS95ZTV3aEN1ZnFF?=
 =?utf-8?B?eDd3V3dXdnJrWlljL0tLUXI4Z3I2ZEF4NkRpb1g3RDhxUXR4Y2hKa1pxYi8v?=
 =?utf-8?B?YkZHa2l1cDcvV25wcUFxbExGZUI0aVBwcE1QNk00SVpXb3krdlFvQTZmRnpC?=
 =?utf-8?B?K0RaY21hcnZiTHNZSFhSNW0yRWprMUR2YjZKYk8rTFpxR2FOekdOSlZTdEJi?=
 =?utf-8?B?amtYSUIzejRjYXo1SEJNM1RVMlJ0V24xMXpINm8wRGlDbFpuL3hQZlZ6U2o0?=
 =?utf-8?B?ZDBGMlhEb1M4MFNRTFR0dlk1YW5pS0NXNk1NTW1CZkVtWldDZnNLbExsVVBJ?=
 =?utf-8?B?NFdHREtzZWlPMDJHV3pYVUFxTHcvNHlmOVdmeEdWUFpmUVZkcFo5UGRUd0tU?=
 =?utf-8?B?dDlGdmd5L29jK1Bla0hZeU1sRVNkWUVpeERNWm84b3lXWWd2d2F0R3QrU093?=
 =?utf-8?B?aVRTbS9qZmRYKzlDeVA0SXhQVnVld0ErMUhXRUJrUjlocXhIY2ZIaUI1d1R1?=
 =?utf-8?B?b1FHZU80aDFYeGNxSDQvNVZJMXlEblFtbzJSUUFOeXFEbzlIS3h1eWZtQjg0?=
 =?utf-8?B?SG9DelVScEhMZmxUWVJtTlk3V0QzMytpUVFnMElYVE1rWVJZT01wejRid2Zp?=
 =?utf-8?B?Z0hITStpOGh4YStYKzVleGJkTE80WVg3Z2RCMVFvcmpyNHNzL1pHZjBYTksr?=
 =?utf-8?B?R1lUK0JsRzBUcm9MbVVLdFZXS3FKZVdUdzRwRlFieXAyN0l2bms0QjQ5eXR3?=
 =?utf-8?B?ako5TlYybS9EajJGWlRsLzQxaWhrVEFnMXJ0ZTF4NDR5elhBYUFGTHZTYnRr?=
 =?utf-8?B?ekcyVDd2WS9PSGkzM2lmUzZ2OXBSUjlVWkJyN3ZFOWpjZWVlNXJTRURQTXdC?=
 =?utf-8?B?UDVDbkYvYm5NVTE3R050a29wQnh0SHg4d0hXeHViM3oxR0Y2a2Rjc1J5VW9w?=
 =?utf-8?B?UnhHd2VyaE5ZUEVTU0VOY0psSjhHUGRhY3pDa3ppYTJZbkphaXE0OFY0V2hB?=
 =?utf-8?B?TlhiT2dRc0FLN1YvWTZJMGtiWUNha3U1Q0VCQ3F0d01VTWxEUHRteWZnY01a?=
 =?utf-8?B?TFNKNzg0cnkzaGova3dLclA5cXJEZHVmU0FRcUd5bTl3N2lOS1JRMmxtWFFp?=
 =?utf-8?B?SHp5UDd4cldUSjlGRktVaXpsZmo1aFJVMzZjdVZMN2FlK1JZTVhHRmh6YWZs?=
 =?utf-8?B?cDhMZ2tiRDRQN1k4NndVSWFUUU8yNFltUm1aaXVOOG1TWFZLbkM1aDk4Wm5u?=
 =?utf-8?B?d2VnNUx5OHBRWitzQ1N2Y2ZUR3ZGODBobkVWSDhGV3p6MHY0RDZYRmVBeGxl?=
 =?utf-8?B?VEtZc3dEcEdHUFg1SkdGYk5wTEFnRHlFcXQ3MmVZMy9WTU9yRXZMc2JpNUww?=
 =?utf-8?B?M2VrWnBoRVRqdTJFbG0rU0VqdXYwT3VaWmJLMHdKMHZ0cFFJQm1pVmNBTjVU?=
 =?utf-8?B?dWl1bWhUR0JIUXE4dkE1ak80TkF4Ym9jWE83Z0J4YzUwYkYvUDJMb3dOY2gy?=
 =?utf-8?B?SXROTkxybjY5ME9YbG1WenJ2a3ZCMm80OUN6SkVkdVFlanNRKzhOLy9tQ0Mv?=
 =?utf-8?B?bXZSa3Y0U0o4NnU2bGY3VVY1YnFNZEx3T1JOZ1MrR3I4YVhpNGFzMnFoZ29U?=
 =?utf-8?B?V0IvUkhsRStCblpwcXFNZWNYZFhrQlZHUWxNbk1wY1R4WjVndm1wUk5BWEdu?=
 =?utf-8?Q?K1Y3EhED1UeH/vOfhBNR+v3HW?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?eStZajM0MllHWUI2cTdtZnJNS05UMEtpNDZhTk9vN3BKeEtWWkFna2wyYXp0?=
 =?utf-8?B?anIrK1ZvMHI3bXFScW9HOUlpaEJDMldza1ZaeFdWYmtLUHB3cThaNnd1bTQx?=
 =?utf-8?B?TlNRZzhkZmZOd3kyRlQ2L1ZYN1dYRlNOdTh6ZUVnc1phM2lDemZtYVN4NFVP?=
 =?utf-8?B?OHYyc2hScEdlemc0NEJQbzd2MFd1MzNBKzlXS2JiSGdJRDVkTklWd20yV0NK?=
 =?utf-8?B?cXZqVGZoWGk4MGh3eHJINWtPSmNmOTNBcEJES2ROR2RXR0g0aS93TlF2Q2hU?=
 =?utf-8?B?U1gwaE1UcXYxUytDK3dDbFVMblJUNXRQY29RdkRXT3MwREpUcVQwTzJRTmtM?=
 =?utf-8?B?MkhwcnFnQ2tvMldEQ3grRSs0dGRzRUhnMjVkTkVwV2ZBTjNVU0Zod3NQZ2FE?=
 =?utf-8?B?ZFZrWVRBOHdZMkRETVVEZldXZFczaFhaOS82OHJaNWFacUNiRXZWZ1lHZ1lk?=
 =?utf-8?B?NWtlRnh4VG5lRjA4TjZyQjVZRkw3R1d4RlhlaGw2aUZ1OHlPa3Y2QU12Vyth?=
 =?utf-8?B?NEdPVjR3UlVkbmc1K2Y4MFJHM0xWZ0lsaFpIcS9DNFpDdjIxMWlwQXU0YmZn?=
 =?utf-8?B?c1I4VWxxN3NaRFkxN25hSWIwb1ZYQWg1Y2t2eWFmTlMvWEhrQXZ2ajhOR2lS?=
 =?utf-8?B?M292QTJ1N2xRYnZpQzBrVm1YZGhJS1JCbHEveE5nWHlzdVlzOGYyQ1JmZlQ3?=
 =?utf-8?B?R25xVFJZS2tIdVZ5OVd1YTBYSmIrSXowSTNnKzdkN2RKdndUSEhBTWpReVc3?=
 =?utf-8?B?YlV1MXJNKzBIVm5odUJET1NzWTJBWnRCS3hzd3diR0trMFNJODdTSWZuSjFC?=
 =?utf-8?B?V0hUcTN4emZ5WWxvQlBOQ1A1WmxNK3hxMWdOYVZWL01CUm1wS1RTc0lmTnRR?=
 =?utf-8?B?V3o1aTZzdFc5SFlMN2lodVVGcUFxUlZzV0hseUNlakpyKzlIVWtSK3VIOEtB?=
 =?utf-8?B?N1ZMMVhpYkhpRkhkVGJFcWhOaXJ0MTBhamUyZUdrWHZiUnJxL1VUck5UWUgv?=
 =?utf-8?B?eUZVdXRqYVFoczFDK2RHd2gwbUMxQjV2aGx1bGRiUmZMb00wTFJIS0d3a2Ev?=
 =?utf-8?B?TWk4clRIdTkxdk1ya0hkdytxcy9qbHI4UGtGSEhnczNUWG42QW5yakZwMWdE?=
 =?utf-8?B?VjNDSkQ3UHJjVmZqSGwxUGZmbEV5UjFXdFRWb04xUmsrMnc0RXJ0Znl5TzYz?=
 =?utf-8?B?ZEgxN1VVSXd0aW9lSU9kZ2hqNEY0UTQrbGZ5ZXZFbzFkcnhPSFh1SFh0U1JS?=
 =?utf-8?B?UXFXaTlQNlZ4QldCZGhXbmR1em9USHNmL3Y1cG1YRi9uRHVydz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73adb988-b707-48c6-e67a-08db27155c9d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:28:10.7830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lP7cZ+qVcsQ7pniztGi4TlhsN4IcpIquT8UlsEQ3Ay2Jctb7oOqKtuJRZwwQggJoA3amliZjH7DfVns+JTs1EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6679
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_14,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=313
 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170125
X-Proofpoint-GUID: 0VK4iIvfazfMhk9rKUQYDZAYY8zPCogg
X-Proofpoint-ORIG-GUID: 0VK4iIvfazfMhk9rKUQYDZAYY8zPCogg
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--jchigfkk6fszsaoy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Mar 10, 2023 at 02:36:13PM +0100, Greg Kroah-Hartman wrote:
> From: Kees Cook <keescook@chromium.org>
> 
> [ Upstream commit b13fecb1c3a603c4b8e99b306fecf4f668c11b32 ]
> 
> This converts all the existing DECLARE_TASKLET() (and ...DISABLED)
> macros with DECLARE_TASKLET_OLD() in preparation for refactoring the
> tasklet callback type. All existing DECLARE_TASKLET() users had a "0"
> data argument, it has been removed here as well.
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Stable-dep-of: 1fdeb8b9f29d ("wifi: iwl3945: Add missing check for create_singlethread_workqueue")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

I noticed kernelci.org bot (5.4) reports:

    Build Failures Detected:

    mips:
        ip27_defconfig: (gcc-10) FAIL
        ip28_defconfig: (gcc-10) FAIL
        lasat_defconfig: (gcc-10) FAIL

    Errors summary:

    1    arch/mips/lasat/picvue_proc.c:87:20: error: ‘pvc_display_tasklet’ undeclared (first use in this function)
    1    arch/mips/lasat/picvue_proc.c:42:44: error: expected ‘)’ before ‘&’ token
    1    arch/mips/lasat/picvue_proc.c:33:13: error: ‘pvc_display’ defined but not used [-Werror=unused-function]

Link: https://lore.kernel.org/stable/64041dda.170a0220.8cc25.79c9@mx.google.com/

Here's what I found...
this backport to 5.4.y of:
b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()")
changed all locations of DECLARE_TASKLET with DECLARE_TASKLET_OLD,
except one, in arch/mips/lasat/pcivue_proc.c.

This is due to:
10760dde9be3 ("MIPS: Remove support for LASAT") preceeding
b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()")
upstream and the former not being present in 5.4.y.

I rolled a revert/re-apply with fixes in the attached mbox,
however maybe just a revert makes more sense?  Up to you.

I have yet to try building this on mips, just did this by inspection.

Regards,

--Tom

--jchigfkk6fszsaoy
Content-Type: application/mbox
Content-Disposition: attachment; filename="mips_declare_tasklet.mbox"
Content-Transfer-Encoding: quoted-printable

From 6e27c38c56b4de21adfda9c6b0bcd88f593fd696 Mon Sep 17 00:00:00 2001=0A=
From: Tom Saeger <tom.saeger@oracle.com>=0A=
Date: Fri, 17 Mar 2023 08:25:30 -0600=0A=
Subject: [PATCH 1/2] Revert "treewide: Replace DECLARE_TASKLET() with=0A=
 DECLARE_TASKLET_OLD()"=0A=
MIME-Version: 1.0=0A=
Content-Type: text/plain; charset=3DUTF-8=0A=
Content-Transfer-Encoding: 8bit=0A=
=0A=
This reverts commit 5de7a4254eb2d501cbb59918a152665b29c02109 which=0A=
caused mips build failures.=0A=
=0A=
kernelci.org bot reports:=0A=
=0A=
arch/mips/lasat/picvue_proc.c:87:20: error: =E2=80=98pvc_display_tasklet=E2=
=80=99 undeclared=0A=
(first use in this function)=0A=
arch/mips/lasat/picvue_proc.c:42:44: error: expected =E2=80=98)=E2=80=99 be=
fore =E2=80=98&=E2=80=99 token=0A=
arch/mips/lasat/picvue_proc.c:33:13: error: =E2=80=98pvc_display=E2=80=99 d=
efined but not used=0A=
[-Werror=3Dunused-function]=0A=
=0A=
Link: https://lore.kernel.org/stable/64041dda.170a0220.8cc25.79c9@mx.google=
.com/=0A=
Reported-by: "kernelci.org bot" <bot@kernelci.org>=0A=
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>=0A=
---=0A=
 drivers/input/keyboard/omap-keypad.c   |  2 +-=0A=
 drivers/input/serio/hil_mlc.c          |  2 +-=0A=
 drivers/net/wan/farsync.c              |  4 ++--=0A=
 drivers/s390/crypto/ap_bus.c           |  2 +-=0A=
 drivers/staging/most/dim2/dim2.c       |  2 +-=0A=
 drivers/staging/octeon/ethernet-tx.c   |  2 +-=0A=
 drivers/tty/vt/keyboard.c              |  2 +-=0A=
 drivers/usb/gadget/udc/snps_udc_core.c |  2 +-=0A=
 drivers/usb/host/fhci-sched.c          |  2 +-=0A=
 include/linux/interrupt.h              | 15 +++++----------=0A=
 kernel/backtracetest.c                 |  2 +-=0A=
 kernel/debug/debug_core.c              |  2 +-=0A=
 kernel/irq/resend.c                    |  2 +-=0A=
 net/atm/pppoatm.c                      |  2 +-=0A=
 net/iucv/iucv.c                        |  2 +-=0A=
 sound/drivers/pcsp/pcsp_lib.c          |  2 +-=0A=
 16 files changed, 21 insertions(+), 26 deletions(-)=0A=
=0A=
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/=
omap-keypad.c=0A=
index dbe836c7ff47..5fe7a5633e33 100644=0A=
--- a/drivers/input/keyboard/omap-keypad.c=0A=
+++ b/drivers/input/keyboard/omap-keypad.c=0A=
@@ -46,7 +46,7 @@ struct omap_kp {=0A=
 	unsigned short keymap[];=0A=
 };=0A=
 =0A=
-static DECLARE_TASKLET_DISABLED_OLD(kp_tasklet, omap_kp_tasklet);=0A=
+static DECLARE_TASKLET_DISABLED(kp_tasklet, omap_kp_tasklet, 0);=0A=
 =0A=
 static unsigned int *row_gpios;=0A=
 static unsigned int *col_gpios;=0A=
diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c=
=0A=
index d36e89d6fc54..4c039e4125d9 100644=0A=
--- a/drivers/input/serio/hil_mlc.c=0A=
+++ b/drivers/input/serio/hil_mlc.c=0A=
@@ -77,7 +77,7 @@ static struct timer_list	hil_mlcs_kicker;=0A=
 static int			hil_mlcs_probe, hil_mlc_stop;=0A=
 =0A=
 static void hil_mlcs_process(unsigned long unused);=0A=
-static DECLARE_TASKLET_DISABLED_OLD(hil_mlcs_tasklet, hil_mlcs_process);=
=0A=
+static DECLARE_TASKLET_DISABLED(hil_mlcs_tasklet, hil_mlcs_process, 0);=0A=
 =0A=
 =0A=
 /* #define HIL_MLC_DEBUG */=0A=
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c=0A=
index 6ac6a649d4c2..a2527351f8a7 100644=0A=
--- a/drivers/net/wan/farsync.c=0A=
+++ b/drivers/net/wan/farsync.c=0A=
@@ -569,8 +569,8 @@ static void do_bottom_half_rx(struct fst_card_info *car=
d);=0A=
 static void fst_process_tx_work_q(unsigned long work_q);=0A=
 static void fst_process_int_work_q(unsigned long work_q);=0A=
 =0A=
-static DECLARE_TASKLET_OLD(fst_tx_task, fst_process_tx_work_q);=0A=
-static DECLARE_TASKLET_OLD(fst_int_task, fst_process_int_work_q);=0A=
+static DECLARE_TASKLET(fst_tx_task, fst_process_tx_work_q, 0);=0A=
+static DECLARE_TASKLET(fst_int_task, fst_process_int_work_q, 0);=0A=
 =0A=
 static struct fst_card_info *fst_card_array[FST_MAX_CARDS];=0A=
 static spinlock_t fst_work_q_lock;=0A=
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c=0A=
index fb1de363fb28..5256e3ce84e5 100644=0A=
--- a/drivers/s390/crypto/ap_bus.c=0A=
+++ b/drivers/s390/crypto/ap_bus.c=0A=
@@ -91,7 +91,7 @@ static DECLARE_WORK(ap_scan_work, ap_scan_bus);=0A=
  * Tasklet & timer for AP request polling and interrupts=0A=
  */=0A=
 static void ap_tasklet_fn(unsigned long);=0A=
-static DECLARE_TASKLET_OLD(ap_tasklet, ap_tasklet_fn);=0A=
+static DECLARE_TASKLET(ap_tasklet, ap_tasklet_fn, 0);=0A=
 static DECLARE_WAIT_QUEUE_HEAD(ap_poll_wait);=0A=
 static struct task_struct *ap_poll_kthread;=0A=
 static DEFINE_MUTEX(ap_poll_thread_mutex);=0A=
diff --git a/drivers/staging/most/dim2/dim2.c b/drivers/staging/most/dim2/d=
im2.c=0A=
index 774abedad987..64c979155a49 100644=0A=
--- a/drivers/staging/most/dim2/dim2.c=0A=
+++ b/drivers/staging/most/dim2/dim2.c=0A=
@@ -47,7 +47,7 @@ MODULE_PARM_DESC(fcnt, "Num of frames per sub-buffer for =
sync channels as a powe=0A=
 static DEFINE_SPINLOCK(dim_lock);=0A=
 =0A=
 static void dim2_tasklet_fn(unsigned long data);=0A=
-static DECLARE_TASKLET_OLD(dim2_tasklet, dim2_tasklet_fn);=0A=
+static DECLARE_TASKLET(dim2_tasklet, dim2_tasklet_fn, 0);=0A=
 =0A=
 /**=0A=
  * struct hdm_channel - private structure to keep channel specific data=0A=
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/=
ethernet-tx.c=0A=
index 100b235b5688..fe6e1ae73460 100644=0A=
--- a/drivers/staging/octeon/ethernet-tx.c=0A=
+++ b/drivers/staging/octeon/ethernet-tx.c=0A=
@@ -41,7 +41,7 @@=0A=
 #endif=0A=
 =0A=
 static void cvm_oct_tx_do_cleanup(unsigned long arg);=0A=
-static DECLARE_TASKLET_OLD(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_clean=
up);=0A=
+static DECLARE_TASKLET(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_cleanup, =
0);=0A=
 =0A=
 /* Maximum number of SKBs to try to free per xmit packet. */=0A=
 #define MAX_SKB_TO_FREE (MAX_OUT_QUEUE_DEPTH * 2)=0A=
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c=0A=
index 0da9e0ab045b..68643f61f6f9 100644=0A=
--- a/drivers/tty/vt/keyboard.c=0A=
+++ b/drivers/tty/vt/keyboard.c=0A=
@@ -1241,7 +1241,7 @@ static void kbd_bh(unsigned long dummy)=0A=
 	}=0A=
 }=0A=
 =0A=
-DECLARE_TASKLET_DISABLED_OLD(keyboard_tasklet, kbd_bh);=0A=
+DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);=0A=
 =0A=
 #if defined(CONFIG_X86) || defined(CONFIG_IA64) || defined(CONFIG_ALPHA) |=
|\=0A=
     defined(CONFIG_MIPS) || defined(CONFIG_PPC) || defined(CONFIG_SPARC) |=
|\=0A=
diff --git a/drivers/usb/gadget/udc/snps_udc_core.c b/drivers/usb/gadget/ud=
c/snps_udc_core.c=0A=
index e76f1a50b0fc..afdd28f332ce 100644=0A=
--- a/drivers/usb/gadget/udc/snps_udc_core.c=0A=
+++ b/drivers/usb/gadget/udc/snps_udc_core.c=0A=
@@ -96,7 +96,7 @@ static int stop_pollstall_timer;=0A=
 static DECLARE_COMPLETION(on_pollstall_exit);=0A=
 =0A=
 /* tasklet for usb disconnect */=0A=
-static DECLARE_TASKLET_OLD(disconnect_tasklet, udc_tasklet_disconnect);=0A=
+static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect, 0);=0A=
 =0A=
 /* endpoint names used for print */=0A=
 static const char ep0_string[] =3D "ep0in";=0A=
diff --git a/drivers/usb/host/fhci-sched.c b/drivers/usb/host/fhci-sched.c=
=0A=
index 5c423f240a1f..3235d5307403 100644=0A=
--- a/drivers/usb/host/fhci-sched.c=0A=
+++ b/drivers/usb/host/fhci-sched.c=0A=
@@ -677,7 +677,7 @@ static void process_done_list(unsigned long data)=0A=
 	enable_irq(fhci_to_hcd(fhci)->irq);=0A=
 }=0A=
 =0A=
-DECLARE_TASKLET_OLD(fhci_tasklet, process_done_list);=0A=
+DECLARE_TASKLET(fhci_tasklet, process_done_list, 0);=0A=
 =0A=
 /* transfer complted callback */=0A=
 u32 fhci_transfer_confirm_callback(struct fhci_hcd *fhci)=0A=
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h=0A=
index 30e92536c78c..89fc59dab57d 100644=0A=
--- a/include/linux/interrupt.h=0A=
+++ b/include/linux/interrupt.h=0A=
@@ -598,17 +598,12 @@ struct tasklet_struct=0A=
 	unsigned long data;=0A=
 };=0A=
 =0A=
-#define DECLARE_TASKLET_OLD(name, _func)		\=0A=
-struct tasklet_struct name =3D {				\=0A=
-	.count =3D ATOMIC_INIT(0),			\=0A=
-	.func =3D _func,					\=0A=
-}=0A=
+#define DECLARE_TASKLET(name, func, data) \=0A=
+struct tasklet_struct name =3D { NULL, 0, ATOMIC_INIT(0), func, data }=0A=
+=0A=
+#define DECLARE_TASKLET_DISABLED(name, func, data) \=0A=
+struct tasklet_struct name =3D { NULL, 0, ATOMIC_INIT(1), func, data }=0A=
 =0A=
-#define DECLARE_TASKLET_DISABLED_OLD(name, _func)	\=0A=
-struct tasklet_struct name =3D {				\=0A=
-	.count =3D ATOMIC_INIT(1),			\=0A=
-	.func =3D _func,					\=0A=
-}=0A=
 =0A=
 enum=0A=
 {=0A=
diff --git a/kernel/backtracetest.c b/kernel/backtracetest.c=0A=
index 370217dd7e39..a2a97fa3071b 100644=0A=
--- a/kernel/backtracetest.c=0A=
+++ b/kernel/backtracetest.c=0A=
@@ -29,7 +29,7 @@ static void backtrace_test_irq_callback(unsigned long dat=
a)=0A=
 	complete(&backtrace_work);=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET_OLD(backtrace_tasklet, &backtrace_test_irq_callback=
);=0A=
+static DECLARE_TASKLET(backtrace_tasklet, &backtrace_test_irq_callback, 0)=
;=0A=
 =0A=
 static void backtrace_test_irq(void)=0A=
 {=0A=
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c=0A=
index f88611fadb19..565987557ad8 100644=0A=
--- a/kernel/debug/debug_core.c=0A=
+++ b/kernel/debug/debug_core.c=0A=
@@ -1043,7 +1043,7 @@ static void kgdb_tasklet_bpt(unsigned long ing)=0A=
 	atomic_set(&kgdb_break_tasklet_var, 0);=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET_OLD(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt);=0A=
+static DECLARE_TASKLET(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt, 0);=0A=
 =0A=
 void kgdb_schedule_breakpoint(void)=0A=
 {=0A=
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c=0A=
index b7af39e36341..98c04ca5fa43 100644=0A=
--- a/kernel/irq/resend.c=0A=
+++ b/kernel/irq/resend.c=0A=
@@ -45,7 +45,7 @@ static void resend_irqs(unsigned long arg)=0A=
 }=0A=
 =0A=
 /* Tasklet to handle resend: */=0A=
-static DECLARE_TASKLET_OLD(resend_tasklet, resend_irqs);=0A=
+static DECLARE_TASKLET(resend_tasklet, resend_irqs, 0);=0A=
 =0A=
 #endif=0A=
 =0A=
diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c=0A=
index 579b66da1d95..45d8e1d5d033 100644=0A=
--- a/net/atm/pppoatm.c=0A=
+++ b/net/atm/pppoatm.c=0A=
@@ -393,7 +393,7 @@ static int pppoatm_assign_vcc(struct atm_vcc *atmvcc, v=
oid __user *arg)=0A=
 	 * Each PPPoATM instance has its own tasklet - this is just a=0A=
 	 * prototypical one used to initialize them=0A=
 	 */=0A=
-	static const DECLARE_TASKLET_OLD(tasklet_proto, pppoatm_wakeup_sender);=
=0A=
+	static const DECLARE_TASKLET(tasklet_proto, pppoatm_wakeup_sender, 0);=0A=
 	if (copy_from_user(&be, arg, sizeof be))=0A=
 		return -EFAULT;=0A=
 	if (be.encaps !=3D PPPOATM_ENCAPS_AUTODETECT &&=0A=
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c=0A=
index a4d1b5b7a154..9a2d023842fe 100644=0A=
--- a/net/iucv/iucv.c=0A=
+++ b/net/iucv/iucv.c=0A=
@@ -128,7 +128,7 @@ static LIST_HEAD(iucv_task_queue);=0A=
  * The tasklet for fast delivery of iucv interrupts.=0A=
  */=0A=
 static void iucv_tasklet_fn(unsigned long);=0A=
-static DECLARE_TASKLET_OLD(iucv_tasklet, iucv_tasklet_fn);=0A=
+static DECLARE_TASKLET(iucv_tasklet, iucv_tasklet_fn,0);=0A=
 =0A=
 /*=0A=
  * Queue of interrupt buffers for delivery via a work queue=0A=
diff --git a/sound/drivers/pcsp/pcsp_lib.c b/sound/drivers/pcsp/pcsp_lib.c=
=0A=
index ce5bab7425d5..8f0f05bbc081 100644=0A=
--- a/sound/drivers/pcsp/pcsp_lib.c=0A=
+++ b/sound/drivers/pcsp/pcsp_lib.c=0A=
@@ -36,7 +36,7 @@ static void pcsp_call_pcm_elapsed(unsigned long priv)=0A=
 	}=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET_OLD(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed);=0A=
+static DECLARE_TASKLET(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed, 0);=0A=
 =0A=
 /* write the port and returns the next expire time in ns;=0A=
  * called at the trigger-start and in hrtimer callback=0A=
-- =0A=
2.40.0=0A=
=0A=
=0A=
From a103c82dc3891874259ba32464507463848a4b84 Mon Sep 17 00:00:00 2001=0A=
From: Kees Cook <keescook@chromium.org>=0A=
Date: Mon, 13 Jul 2020 15:01:26 -0700=0A=
Subject: [PATCH 2/2] treewide: Replace DECLARE_TASKLET() with=0A=
 DECLARE_TASKLET_OLD()=0A=
=0A=
[ Upstream commit b13fecb1c3a603c4b8e99b306fecf4f668c11b32 ]=0A=
=0A=
This converts all the existing DECLARE_TASKLET() (and ...DISABLED)=0A=
macros with DECLARE_TASKLET_OLD() in preparation for refactoring the=0A=
tasklet callback type. All existing DECLARE_TASKLET() users had a "0"=0A=
data argument, it has been removed here as well.=0A=
=0A=
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=0A=
Acked-by: Thomas Gleixner <tglx@linutronix.de>=0A=
Signed-off-by: Kees Cook <keescook@chromium.org>=0A=
Stable-dep-of: 1fdeb8b9f29d ("wifi: iwl3945: Add missing check for create_s=
inglethread_workqueue")=0A=
Signed-off-by: Sasha Levin <sashal@kernel.org>=0A=
[Tom: fix backport to 5.4.y]=0A=
=0A=
AUTOSEL backport to 5.4.y of:=0A=
b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD=
()")=0A=
changed all locations of DECLARE_TASKLET with DECLARE_TASKLET_OLD,=0A=
except one, in arch/mips/lasat/pcivue_proc.c.=0A=
=0A=
This is due to:=0A=
10760dde9be3 ("MIPS: Remove support for LASAT") preceeding=0A=
b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD=
()")=0A=
upstream and the former not being present in 5.4.y.=0A=
=0A=
Fix this by changing DECLARE_TASKLET to DECLARE_TASKLET_OLD in=0A=
arch/mips/lasat/pcivue_proc.c.=0A=
=0A=
Fixes: 5de7a4254eb2 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASK=
LET_OLD()")=0A=
Reported-by: "kernelci.org bot" <bot@kernelci.org>=0A=
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>=0A=
---=0A=
 arch/mips/lasat/picvue_proc.c          |  2 +-=0A=
 drivers/input/keyboard/omap-keypad.c   |  2 +-=0A=
 drivers/input/serio/hil_mlc.c          |  2 +-=0A=
 drivers/net/wan/farsync.c              |  4 ++--=0A=
 drivers/s390/crypto/ap_bus.c           |  2 +-=0A=
 drivers/staging/most/dim2/dim2.c       |  2 +-=0A=
 drivers/staging/octeon/ethernet-tx.c   |  2 +-=0A=
 drivers/tty/vt/keyboard.c              |  2 +-=0A=
 drivers/usb/gadget/udc/snps_udc_core.c |  2 +-=0A=
 drivers/usb/host/fhci-sched.c          |  2 +-=0A=
 include/linux/interrupt.h              | 15 ++++++++++-----=0A=
 kernel/backtracetest.c                 |  2 +-=0A=
 kernel/debug/debug_core.c              |  2 +-=0A=
 kernel/irq/resend.c                    |  2 +-=0A=
 net/atm/pppoatm.c                      |  2 +-=0A=
 net/iucv/iucv.c                        |  2 +-=0A=
 sound/drivers/pcsp/pcsp_lib.c          |  2 +-=0A=
 17 files changed, 27 insertions(+), 22 deletions(-)=0A=
=0A=
diff --git a/arch/mips/lasat/picvue_proc.c b/arch/mips/lasat/picvue_proc.c=
=0A=
index 8126f15b8e09..439127e92521 100644=0A=
--- a/arch/mips/lasat/picvue_proc.c=0A=
+++ b/arch/mips/lasat/picvue_proc.c=0A=
@@ -39,7 +39,7 @@ static void pvc_display(unsigned long data)=0A=
 		pvc_write_string(pvc_lines[i], 0, i);=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET(pvc_display_tasklet, &pvc_display, 0);=0A=
+static DECLARE_TASKLET_OLD(pvc_display_tasklet, &pvc_display, 0);=0A=
 =0A=
 static int pvc_line_proc_show(struct seq_file *m, void *v)=0A=
 {=0A=
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/=
omap-keypad.c=0A=
index 5fe7a5633e33..dbe836c7ff47 100644=0A=
--- a/drivers/input/keyboard/omap-keypad.c=0A=
+++ b/drivers/input/keyboard/omap-keypad.c=0A=
@@ -46,7 +46,7 @@ struct omap_kp {=0A=
 	unsigned short keymap[];=0A=
 };=0A=
 =0A=
-static DECLARE_TASKLET_DISABLED(kp_tasklet, omap_kp_tasklet, 0);=0A=
+static DECLARE_TASKLET_DISABLED_OLD(kp_tasklet, omap_kp_tasklet);=0A=
 =0A=
 static unsigned int *row_gpios;=0A=
 static unsigned int *col_gpios;=0A=
diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c=
=0A=
index 4c039e4125d9..d36e89d6fc54 100644=0A=
--- a/drivers/input/serio/hil_mlc.c=0A=
+++ b/drivers/input/serio/hil_mlc.c=0A=
@@ -77,7 +77,7 @@ static struct timer_list	hil_mlcs_kicker;=0A=
 static int			hil_mlcs_probe, hil_mlc_stop;=0A=
 =0A=
 static void hil_mlcs_process(unsigned long unused);=0A=
-static DECLARE_TASKLET_DISABLED(hil_mlcs_tasklet, hil_mlcs_process, 0);=0A=
+static DECLARE_TASKLET_DISABLED_OLD(hil_mlcs_tasklet, hil_mlcs_process);=
=0A=
 =0A=
 =0A=
 /* #define HIL_MLC_DEBUG */=0A=
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c=0A=
index a2527351f8a7..6ac6a649d4c2 100644=0A=
--- a/drivers/net/wan/farsync.c=0A=
+++ b/drivers/net/wan/farsync.c=0A=
@@ -569,8 +569,8 @@ static void do_bottom_half_rx(struct fst_card_info *car=
d);=0A=
 static void fst_process_tx_work_q(unsigned long work_q);=0A=
 static void fst_process_int_work_q(unsigned long work_q);=0A=
 =0A=
-static DECLARE_TASKLET(fst_tx_task, fst_process_tx_work_q, 0);=0A=
-static DECLARE_TASKLET(fst_int_task, fst_process_int_work_q, 0);=0A=
+static DECLARE_TASKLET_OLD(fst_tx_task, fst_process_tx_work_q);=0A=
+static DECLARE_TASKLET_OLD(fst_int_task, fst_process_int_work_q);=0A=
 =0A=
 static struct fst_card_info *fst_card_array[FST_MAX_CARDS];=0A=
 static spinlock_t fst_work_q_lock;=0A=
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c=0A=
index 5256e3ce84e5..fb1de363fb28 100644=0A=
--- a/drivers/s390/crypto/ap_bus.c=0A=
+++ b/drivers/s390/crypto/ap_bus.c=0A=
@@ -91,7 +91,7 @@ static DECLARE_WORK(ap_scan_work, ap_scan_bus);=0A=
  * Tasklet & timer for AP request polling and interrupts=0A=
  */=0A=
 static void ap_tasklet_fn(unsigned long);=0A=
-static DECLARE_TASKLET(ap_tasklet, ap_tasklet_fn, 0);=0A=
+static DECLARE_TASKLET_OLD(ap_tasklet, ap_tasklet_fn);=0A=
 static DECLARE_WAIT_QUEUE_HEAD(ap_poll_wait);=0A=
 static struct task_struct *ap_poll_kthread;=0A=
 static DEFINE_MUTEX(ap_poll_thread_mutex);=0A=
diff --git a/drivers/staging/most/dim2/dim2.c b/drivers/staging/most/dim2/d=
im2.c=0A=
index 64c979155a49..774abedad987 100644=0A=
--- a/drivers/staging/most/dim2/dim2.c=0A=
+++ b/drivers/staging/most/dim2/dim2.c=0A=
@@ -47,7 +47,7 @@ MODULE_PARM_DESC(fcnt, "Num of frames per sub-buffer for =
sync channels as a powe=0A=
 static DEFINE_SPINLOCK(dim_lock);=0A=
 =0A=
 static void dim2_tasklet_fn(unsigned long data);=0A=
-static DECLARE_TASKLET(dim2_tasklet, dim2_tasklet_fn, 0);=0A=
+static DECLARE_TASKLET_OLD(dim2_tasklet, dim2_tasklet_fn);=0A=
 =0A=
 /**=0A=
  * struct hdm_channel - private structure to keep channel specific data=0A=
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/=
ethernet-tx.c=0A=
index fe6e1ae73460..100b235b5688 100644=0A=
--- a/drivers/staging/octeon/ethernet-tx.c=0A=
+++ b/drivers/staging/octeon/ethernet-tx.c=0A=
@@ -41,7 +41,7 @@=0A=
 #endif=0A=
 =0A=
 static void cvm_oct_tx_do_cleanup(unsigned long arg);=0A=
-static DECLARE_TASKLET(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_cleanup, =
0);=0A=
+static DECLARE_TASKLET_OLD(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_clean=
up);=0A=
 =0A=
 /* Maximum number of SKBs to try to free per xmit packet. */=0A=
 #define MAX_SKB_TO_FREE (MAX_OUT_QUEUE_DEPTH * 2)=0A=
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c=0A=
index 68643f61f6f9..0da9e0ab045b 100644=0A=
--- a/drivers/tty/vt/keyboard.c=0A=
+++ b/drivers/tty/vt/keyboard.c=0A=
@@ -1241,7 +1241,7 @@ static void kbd_bh(unsigned long dummy)=0A=
 	}=0A=
 }=0A=
 =0A=
-DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);=0A=
+DECLARE_TASKLET_DISABLED_OLD(keyboard_tasklet, kbd_bh);=0A=
 =0A=
 #if defined(CONFIG_X86) || defined(CONFIG_IA64) || defined(CONFIG_ALPHA) |=
|\=0A=
     defined(CONFIG_MIPS) || defined(CONFIG_PPC) || defined(CONFIG_SPARC) |=
|\=0A=
diff --git a/drivers/usb/gadget/udc/snps_udc_core.c b/drivers/usb/gadget/ud=
c/snps_udc_core.c=0A=
index afdd28f332ce..e76f1a50b0fc 100644=0A=
--- a/drivers/usb/gadget/udc/snps_udc_core.c=0A=
+++ b/drivers/usb/gadget/udc/snps_udc_core.c=0A=
@@ -96,7 +96,7 @@ static int stop_pollstall_timer;=0A=
 static DECLARE_COMPLETION(on_pollstall_exit);=0A=
 =0A=
 /* tasklet for usb disconnect */=0A=
-static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect, 0);=0A=
+static DECLARE_TASKLET_OLD(disconnect_tasklet, udc_tasklet_disconnect);=0A=
 =0A=
 /* endpoint names used for print */=0A=
 static const char ep0_string[] =3D "ep0in";=0A=
diff --git a/drivers/usb/host/fhci-sched.c b/drivers/usb/host/fhci-sched.c=
=0A=
index 3235d5307403..5c423f240a1f 100644=0A=
--- a/drivers/usb/host/fhci-sched.c=0A=
+++ b/drivers/usb/host/fhci-sched.c=0A=
@@ -677,7 +677,7 @@ static void process_done_list(unsigned long data)=0A=
 	enable_irq(fhci_to_hcd(fhci)->irq);=0A=
 }=0A=
 =0A=
-DECLARE_TASKLET(fhci_tasklet, process_done_list, 0);=0A=
+DECLARE_TASKLET_OLD(fhci_tasklet, process_done_list);=0A=
 =0A=
 /* transfer complted callback */=0A=
 u32 fhci_transfer_confirm_callback(struct fhci_hcd *fhci)=0A=
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h=0A=
index 89fc59dab57d..30e92536c78c 100644=0A=
--- a/include/linux/interrupt.h=0A=
+++ b/include/linux/interrupt.h=0A=
@@ -598,12 +598,17 @@ struct tasklet_struct=0A=
 	unsigned long data;=0A=
 };=0A=
 =0A=
-#define DECLARE_TASKLET(name, func, data) \=0A=
-struct tasklet_struct name =3D { NULL, 0, ATOMIC_INIT(0), func, data }=0A=
-=0A=
-#define DECLARE_TASKLET_DISABLED(name, func, data) \=0A=
-struct tasklet_struct name =3D { NULL, 0, ATOMIC_INIT(1), func, data }=0A=
+#define DECLARE_TASKLET_OLD(name, _func)		\=0A=
+struct tasklet_struct name =3D {				\=0A=
+	.count =3D ATOMIC_INIT(0),			\=0A=
+	.func =3D _func,					\=0A=
+}=0A=
 =0A=
+#define DECLARE_TASKLET_DISABLED_OLD(name, _func)	\=0A=
+struct tasklet_struct name =3D {				\=0A=
+	.count =3D ATOMIC_INIT(1),			\=0A=
+	.func =3D _func,					\=0A=
+}=0A=
 =0A=
 enum=0A=
 {=0A=
diff --git a/kernel/backtracetest.c b/kernel/backtracetest.c=0A=
index a2a97fa3071b..370217dd7e39 100644=0A=
--- a/kernel/backtracetest.c=0A=
+++ b/kernel/backtracetest.c=0A=
@@ -29,7 +29,7 @@ static void backtrace_test_irq_callback(unsigned long dat=
a)=0A=
 	complete(&backtrace_work);=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET(backtrace_tasklet, &backtrace_test_irq_callback, 0)=
;=0A=
+static DECLARE_TASKLET_OLD(backtrace_tasklet, &backtrace_test_irq_callback=
);=0A=
 =0A=
 static void backtrace_test_irq(void)=0A=
 {=0A=
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c=0A=
index 565987557ad8..f88611fadb19 100644=0A=
--- a/kernel/debug/debug_core.c=0A=
+++ b/kernel/debug/debug_core.c=0A=
@@ -1043,7 +1043,7 @@ static void kgdb_tasklet_bpt(unsigned long ing)=0A=
 	atomic_set(&kgdb_break_tasklet_var, 0);=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt, 0);=0A=
+static DECLARE_TASKLET_OLD(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt);=0A=
 =0A=
 void kgdb_schedule_breakpoint(void)=0A=
 {=0A=
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c=0A=
index 98c04ca5fa43..b7af39e36341 100644=0A=
--- a/kernel/irq/resend.c=0A=
+++ b/kernel/irq/resend.c=0A=
@@ -45,7 +45,7 @@ static void resend_irqs(unsigned long arg)=0A=
 }=0A=
 =0A=
 /* Tasklet to handle resend: */=0A=
-static DECLARE_TASKLET(resend_tasklet, resend_irqs, 0);=0A=
+static DECLARE_TASKLET_OLD(resend_tasklet, resend_irqs);=0A=
 =0A=
 #endif=0A=
 =0A=
diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c=0A=
index 45d8e1d5d033..579b66da1d95 100644=0A=
--- a/net/atm/pppoatm.c=0A=
+++ b/net/atm/pppoatm.c=0A=
@@ -393,7 +393,7 @@ static int pppoatm_assign_vcc(struct atm_vcc *atmvcc, v=
oid __user *arg)=0A=
 	 * Each PPPoATM instance has its own tasklet - this is just a=0A=
 	 * prototypical one used to initialize them=0A=
 	 */=0A=
-	static const DECLARE_TASKLET(tasklet_proto, pppoatm_wakeup_sender, 0);=0A=
+	static const DECLARE_TASKLET_OLD(tasklet_proto, pppoatm_wakeup_sender);=
=0A=
 	if (copy_from_user(&be, arg, sizeof be))=0A=
 		return -EFAULT;=0A=
 	if (be.encaps !=3D PPPOATM_ENCAPS_AUTODETECT &&=0A=
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c=0A=
index 9a2d023842fe..a4d1b5b7a154 100644=0A=
--- a/net/iucv/iucv.c=0A=
+++ b/net/iucv/iucv.c=0A=
@@ -128,7 +128,7 @@ static LIST_HEAD(iucv_task_queue);=0A=
  * The tasklet for fast delivery of iucv interrupts.=0A=
  */=0A=
 static void iucv_tasklet_fn(unsigned long);=0A=
-static DECLARE_TASKLET(iucv_tasklet, iucv_tasklet_fn,0);=0A=
+static DECLARE_TASKLET_OLD(iucv_tasklet, iucv_tasklet_fn);=0A=
 =0A=
 /*=0A=
  * Queue of interrupt buffers for delivery via a work queue=0A=
diff --git a/sound/drivers/pcsp/pcsp_lib.c b/sound/drivers/pcsp/pcsp_lib.c=
=0A=
index 8f0f05bbc081..ce5bab7425d5 100644=0A=
--- a/sound/drivers/pcsp/pcsp_lib.c=0A=
+++ b/sound/drivers/pcsp/pcsp_lib.c=0A=
@@ -36,7 +36,7 @@ static void pcsp_call_pcm_elapsed(unsigned long priv)=0A=
 	}=0A=
 }=0A=
 =0A=
-static DECLARE_TASKLET(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed, 0);=0A=
+static DECLARE_TASKLET_OLD(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed);=0A=
 =0A=
 /* write the port and returns the next expire time in ns;=0A=
  * called at the trigger-start and in hrtimer callback=0A=
-- =0A=
2.40.0=0A=
=0A=

--jchigfkk6fszsaoy--
