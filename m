Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A595F0BBA
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 14:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiI3M1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 08:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiI3M1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 08:27:07 -0400
Received: from CHE01-GV0-obe.outbound.protection.outlook.com (mail-gv0che01on2059.outbound.protection.outlook.com [40.107.23.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B24012B49C
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 05:27:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYOx/Tl4f1iw1TAxUy7bsU7uCOYQkQ++nPPkbkSjJPdOVqvhQhoFP8MbgUE6ZbJACnorkDsfFUNv1yPuB2JAYHRrv6EbtGxSqVPT07lcnMsr5dqOZ7YXLlkoY/RqhTDcghwwE4fWH5h4MaAlYP/yJPdeuaO1VWr3GtAm4CR7tbIUGLZXrURNNGd8i6kizLUNwRT1F3kCk6bcNSq6IZ42JTHywelWzCERkhgSatMF0EYKs/lN+wItQUWAhg+A3J0+RYJ8JFmCpZ2N5wDF+VogsNg/rW4P6sKRF9LEAHz1vuOK0+eQvsh9AkmwAoso7dmnYCd/fDwFe7tno3/WwWqEtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Mfus4qDagG27V2Zakgj8yK99LZRK4cZ05yOx23ggfk=;
 b=CRcyLc4oI254um1zRhh2KmiUXKmsURumrSOaOZTGIZihH8JRP690AbItbIzge6jEzgF9NSR41CC/BIrAXTMUpp9NaHgbDMF88oBX9dfizmRzjS+KoG8aq7EfoqeQDYJJxjHJ1/nRg816EstOFHJZdz84EIOWbCO2PipDBQwJyuqKQk9xQyY1Bq5p0U3NOlFs8mUQmgwWK2sTtEO9OljAgWRP54e5K+qqj2dsIXasIWa4SBEQiBsf6MzMn0XozRaNAryuOYs3frvORU2NQ8vD+vBxrB8wKkohnIzFYPcs3sqF19jlhhnCaSIIOnaromrlK6g4uBjdNX76WKqDFNWJAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 188.184.36.48) smtp.rcpttodomain=sladewatkins.net smtp.mailfrom=cern.ch;
 dmarc=bestguesspass action=none header.from=cern.ch; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cern.onmicrosoft.com;
 s=selector2-cern-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Mfus4qDagG27V2Zakgj8yK99LZRK4cZ05yOx23ggfk=;
 b=PvUAGLXcBduQ9xaHLVPj9ywZglLPICfABigjVmNTiXmiyesyTZHzGYX2gY2NNDxx/A8cRj+7OZaLtD1c5s9kWG3inpW5ifCHB7TVCy5MUQic37yTxGP4qIL2B45uxDHzlSRXQf1iFZAHCx1376kdTNhoGZYv21LTkIJqTP+Wn1U=
Received: from GV2PEPF000000ED.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:144:1:0:1:0:16) by ZR0P278MB0074.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:19::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 12:27:04 +0000
Received: from HE1EUR02FT098.eop-EUR02.prod.protection.outlook.com
 (2a01:111:f400:7e05::205) by GV2PEPF000000ED.outlook.office365.com
 (2603:1026:900::3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23 via Frontend
 Transport; Fri, 30 Sep 2022 12:27:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 188.184.36.48)
 smtp.mailfrom=cern.ch; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=cern.ch;
Received-SPF: Pass (protection.outlook.com: domain of cern.ch designates
 188.184.36.48 as permitted sender) receiver=protection.outlook.com;
 client-ip=188.184.36.48; helo=cernmxgwlb4.cern.ch; pr=C
Received: from cernmxgwlb4.cern.ch (188.184.36.48) by
 HE1EUR02FT098.mail.protection.outlook.com (10.152.10.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5676.17 via Frontend Transport; Fri, 30 Sep 2022 12:27:03 +0000
Received: from cernfe04.cern.ch (188.184.36.41) by cernmxgwlb4.cern.ch
 (188.184.36.48) with Microsoft SMTP Server (TLS) id 14.3.498.0; Fri, 30 Sep
 2022 14:26:43 +0200
Received: from [192.168.1.25] (24.61.185.63) by smtp.cern.ch (188.184.36.52)
 with Microsoft SMTP Server (TLS) id 14.3.498.0; Fri, 30 Sep 2022 14:26:42
 +0200
Message-ID: <aa8b9724-50c6-ae2e-062d-3791144ac97e@cern.ch>
Date:   Fri, 30 Sep 2022 08:26:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: Regression on 5.19.12, display flickering on Framework laptop
To:     Slade Watkins <srw@sladewatkins.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <regressions@lists.linux.dev>
References: <55905860-adf9-312c-69cc-491ac8ce1a8b@cern.ch>
 <YzZynE2FAMNQKm2E@kroah.com> <YzaFq7fzw5TbrJyv@kroah.com>
 <03147889-B21C-449B-B110-7E504C8B0EF4@sladewatkins.net>
Content-Language: en-US
From:   Jerry Ling <jiling@cern.ch>
In-Reply-To: <03147889-B21C-449B-B110-7E504C8B0EF4@sladewatkins.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.61.185.63]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1EUR02FT098:EE_|ZR0P278MB0074:EE_
X-MS-Office365-Filtering-Correlation-Id: c27ac56b-ae01-4d86-1946-08daa2df14b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FcVpk7ZfRIQsa0/jlfJSy9KOJmsokafSJ/7MRQvLVrHvWrEgrsBpaog/1kpvq5S0cgHKuf/+NkX+tNGer1REHIBYvRYQ7DiNW1d4jUlcl/ax7ZxaALj4VkSqAfyx547bzkKerz6UNNCD90T0U3gxO72k0PFugeqPzWtl/guJoTU4wGnLPbSDMA75Le9yQoTHnHe9xTkYCvsh+EXZmHuqlXVC3j8BY1wM6BNbHG4j1fwBubjFf07FJb3QKfk93IC0qG3X0FNEW/5jbMmbOSYHxhe+reYxTDf5csFsszP+nBD+B+onTmpieskRu7vB+pmqoP74PTVx1NzB/UZGZ0G2Bkymni6qJX6dGXaZZm5gyqr9I7VymBySGs/WCmAa9+GWlHz6UtlgwuxthiF/KwXP58w0ThIli2Yawfk9L+Nf2MURPwbserKfg66OrltBW52m3OLVrXNP7uaQpBjkLolac0OpD4Vb6jYAiXI5Z2GTf8kd136mZ1hb68mG8QarMRrSQpAOlGzqwoq6fvYa4IJPw7G5gCdcURMz72mktVS30tHY1EDid6GgzzJkuNBryNbNWCdjBn+3d/eh24v1FseBAcQTRkeKA89WlLSLDovwvzkfoXhoPQfeErDGZlLQasxABKyPpN4ABUTmNicyIIBdk+FsFoN34Z0gO3QFHw6jDXV1AB2Aa3QQJ4GaiNFU1i4Iu9dlX5WpHfncpJp/05KdKcYZ4hu/IKXfAXKO5ERgH64pJR+/sbF2bYUIM1eYveGUkqoBJn6h/+cJsTQwOPynlfN/1JS0hd5NOWfnSuFpnOwtaWR6128ae6Oh5Cwqmu8ue6wsJg5/AU4TG06jJToXIgzfpbZd2PggE8H1sHs+9AE=
X-Forefront-Antispam-Report: CIP:188.184.36.48;CTRY:CH;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cernmxgwlb4.cern.ch;PTR:cernmx12.cern.ch;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199015)(46966006)(36840700001)(40470700004)(2616005)(8936002)(26005)(5660300002)(356005)(82740400003)(82310400005)(41300700001)(53546011)(7636003)(336012)(16526019)(16799955002)(186003)(36756003)(47076005)(83380400001)(426003)(36860700001)(34070700002)(956004)(110136005)(16576012)(478600001)(316002)(54906003)(786003)(31686004)(70206006)(70586007)(8676002)(40460700003)(4326008)(40480700001)(966005)(41320700001)(31696002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: cern.ch
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 12:27:03.2509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c27ac56b-ae01-4d86-1946-08daa2df14b5
X-MS-Exchange-CrossTenant-Id: c80d3499-4a40-4a8c-986e-abce017d6b19
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=c80d3499-4a40-4a8c-986e-abce017d6b19;Ip=[188.184.36.48];Helo=[cernmxgwlb4.cern.ch]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR02FT098.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0074
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

looks like someone has done it: 
https://bbs.archlinux.org/viewtopic.php?pid=2059823#p2059823

and the bisect points to:

|# first bad commit: [fc6aff984b1c63d6b9e54f5eff9cc5ac5840bc8c] 
drm/i915/bios: Split VBT data into per-panel vs. global parts Best, Jerry |

On 9/30/22 07:11, Slade Watkins wrote:
> Hey Greg,
>
>> On Sep 30, 2022, at 1:59 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> On Fri, Sep 30, 2022 at 06:37:48AM +0200, Greg KH wrote:
>>> On Thu, Sep 29, 2022 at 10:26:25PM -0400, Jerry Ling wrote:
>>>> Hi,
>>>>
>>>> It has been reported by multiple users across a handful of distros that
>>>> there seems to be regression on Framework laptop (which presumably is not
>>>> that special in terms of mobo and display)
>>>>
>>>> Ref: https://community.frame.work/t/psa-dont-upgrade-to-linux-kernel-5-19-12-arch1-1-on-arch-linux-gen-11-model/23171
>>> Can anyone do a 'git bisect' to find the offending commit?
>> Also, this works for me on a gen 12 framework laptop:
>> 	$ uname -a
>> 	Linux frame 5.19.12 #68 SMP PREEMPT_DYNAMIC Fri Sep 30 07:02:33 CEST 2022 x86_64 GNU/Linux
>>
>> so there's something odd with the older hardware?
>>
>> greg k-h
> Could be. Running git bisect for 5.19.11 and 5.19.12 (as suggested by the linked forum thread) returned nothing on gen 11 for me.
>
> This is very odd,
> -srw
