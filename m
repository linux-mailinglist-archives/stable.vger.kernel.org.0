Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076CD5AA2B2
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 00:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbiIAWRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 18:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234349AbiIAWRS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 18:17:18 -0400
Received: from burlywood.elm.relay.mailchannels.net (burlywood.elm.relay.mailchannels.net [23.83.212.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B84726B8
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 15:17:09 -0700 (PDT)
X-Sender-Id: techassets|x-authuser|susanlee20@ingodihop.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 230069219BD;
        Thu,  1 Sep 2022 22:17:08 +0000 (UTC)
Received: from vmcp128.myhostcenter.com (unknown [127.0.0.6])
        (Authenticated sender: techassets)
        by relay.mailchannels.net (Postfix) with ESMTPA id 08724921973;
        Thu,  1 Sep 2022 22:16:57 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1662070627; a=rsa-sha256;
        cv=none;
        b=ysRVC0QRO3QgSrjAa/4//HT8mLRka9eT2ZhQFvJbxUs9/qvc733SYmSif1AK0bZ1RgTv8b
        0U/6DYVXfNzVoszWvahe3IfYOMux2Ily9X645EuuNyI4D/w8n2JDcM6U4PKH+Bbhx0ds/t
        dF8nV8GpF5t8EGGmPV/LHNfRv3kKsi2C4rl7oRB4ti3jMFqfrkk14Hru/dEiUWSu1W7L4P
        S7Qrnn/qW93/wA93laR5/vUpc+vDwK5Ddx133Ey39JC7TtLrXMPaEniCNFlxsANY3GLaxc
        bhu8DM0H0rhPLNzI3Dly9AOOeuA3w8yYreuU7/NpyHWlOwoMk2bIdr7J0FkW6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1662070627;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lk3bJyd8y857dJgjG4s8NjFXdOCsb6gQAFjio/VR4EE=;
        b=v2QnWW8in1NlI2Z243BpURiwf8+ID61RtNbyrmh0dPm6p74qgt2r3iGt4u5jztjbzagvOK
        vNnV2AfKYokAufNOLGCMh2XVsyLMCXpLUXkb3lYUFu5RjE50+hE0uA2AlLZoGMMz+N7KRb
        ypkoTmk7DfgrxKCbxvW0g+6r6BG0kJu8rQAmY4J6zSrTmJFi+I8Ay5BlNM/jyocpcpTX9X
        N80lTi3dcDk3eQ82WSfmEf5ZN87u5BPhNGw0f32qrWylBv828gtvfRzSSVY72GtNm3niJJ
        oOx84TKRNXjWf6IzLSSbIlVJFIWxta1cAwyjI0K+sGuO5Bc5iENjmP38zXI1FA==
ARC-Authentication-Results: i=1;
        rspamd-75b4464bd-zghmx;
        auth=pass smtp.auth=techassets smtp.mailfrom=susanlee20@ingodihop.com
X-Sender-Id: techassets|x-authuser|susanlee20@ingodihop.com
X-MC-Relay: Junk
X-MailChannels-SenderId: techassets|x-authuser|susanlee20@ingodihop.com
X-MailChannels-Auth-Id: techassets
X-Battle-Zesty: 1314f16a158a8e16_1662070627650_2976589238
X-MC-Loop-Signature: 1662070627650:2504978712
X-MC-Ingress-Time: 1662070627650
Received: from vmcp128.myhostcenter.com (vmcp128.myhostcenter.com
 [66.84.29.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.103.147.32 (trex/6.7.1);
        Thu, 01 Sep 2022 22:17:07 +0000
Received: from [::1] (port=49752 helo=vmcp128.myhostcenter.com)
        by vmcp128.myhostcenter.com with esmtpa (Exim 4.95)
        (envelope-from <susanlee20@ingodihop.com>)
        id 1oTsUS-00Ewk7-7F;
        Thu, 01 Sep 2022 18:16:46 -0400
MIME-Version: 1.0
Date:   Thu, 01 Sep 2022 18:16:28 -0400
From:   "Mrs. Susan Lee Yu-Chen " <susanlee20@ingodihop.com>
To:     undisclosed-recipients:;
Subject: INFORMATION
Reply-To: mrs.susanlee22@gmail.com
Mail-Reply-To: mrs.susanlee22@gmail.com
User-Agent: Roundcube Webmail/1.5.2
Message-ID: <b051be52fe665f7645c4e1d0a908de1b@ingodihop.com>
X-Sender: susanlee20@ingodihop.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-AuthUser: susanlee20@ingodihop.com
X-Originating-IP: ::1
X-Spam-Status: Yes, score=6.3 required=5.0 tests=BAYES_50,
        FREEMAIL_FORGED_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,HK_NAME_MR_MRS,
        ODD_FREEM_REPTO,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4696]
        * -0.0 RCVD_IN_MSPIKE_H2 RBL: Average reputation (+2)
        *      [23.83.212.26 listed in wl.mailspike.net]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrs.susanlee22[at]gmail.com]
        *  0.0 T_SPF_PERMERROR SPF: test of record failed (permerror)
        *  2.1 ODD_FREEM_REPTO Has unusual reply-to header
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.0 HK_NAME_MR_MRS No description available.
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



-- 
Hello,

I have sent you two emails and you did not respond, I even sent another 
message a few days ago with more details still no response from you. 
Please are you still using this email address? I am VERY SORRY if 
sincerely you did not receive those emails, I will resend it now as soon 
as you confirm you never received them.

Regards,
Susan Lee Yu-Chen
