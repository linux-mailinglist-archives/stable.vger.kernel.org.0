Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05AF05BA97D
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 11:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiIPJfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 05:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiIPJfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 05:35:06 -0400
Received: from burlywood.elm.relay.mailchannels.net (burlywood.elm.relay.mailchannels.net [23.83.212.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C735A803
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 02:35:04 -0700 (PDT)
X-Sender-Id: techassets|x-authuser|kishpatrick8@ingodihop.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id BCAA56C32BE;
        Fri, 16 Sep 2022 09:35:02 +0000 (UTC)
Received: from vmcp128.myhostcenter.com (unknown [127.0.0.6])
        (Authenticated sender: techassets)
        by relay.mailchannels.net (Postfix) with ESMTPA id 06D886C3041;
        Fri, 16 Sep 2022 09:34:52 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1663320902; a=rsa-sha256;
        cv=none;
        b=25o8/4EyYw/4w5ymVsKfNoWdvqO5gFlZhSNbgnc26WUXLsf/job2cY9JH6sT3EXRBrMJdC
        UCzUYRb1RlrUQspUT6ywm9BYA/8eOt7YFW9koOE2JRe3s/KvQ/rs0oz2Vv9OBuopgF1sfE
        vRQ6pxBbhFvH1MMu1Qen7nJp/BGLpH6a+V++eBJtFMrybFsgoiw1pryKZwrN6BtJDeoU4b
        nG2+nxclriwuPcRYxNsEcjNeBq31VRZ6/oE8bmXzlfB8h/GEev7HKTDGoAiBonN6FnXJzX
        dJEgfZDOQYNQR4oZJcGkpwEfel4EE+a5r0Axw94gzNZ2OtDc81rK5ccO3n7jpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1663320902;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=N5Kt+pGNVJ3Onh2NtEJQN37NB1ZQK6aOFHt59hBeVd0=;
        b=8FBqQMjrLtFwxBv6wEc3eyDqpjDoRnR+ZX3n+XgYxNbwnaPYnAVSVVAtk+su0P0TabfvHa
        uRfveRMVTzoejd9qERxnjJWqOfQZ5mayRFfx+FGCXGAqHP0OOr7GZK42sH0JaX+dlaRmZo
        8N4LBrCR8IdP49Lt/mIC7N0sWv2k/xjlWAH6C4POJp7MaPRfic1Th9CCW5N1ApB7s9+8kh
        lRhcqvMJQuQ2CW+9U/E93lPtKvJFSeXHjee0AUPViyMfGQIg3T56XzL9qAGl+bM2Be62hZ
        6EhiYCXbdXAQHREJcmjjqpsTLqHfn7sB2Op9VTylII5JHHH0Gl9zY/Ei1qk4iQ==
ARC-Authentication-Results: i=1;
        rspamd-686945db84-l24qt;
        auth=pass smtp.auth=techassets smtp.mailfrom=kishpatrick8@ingodihop.com
X-Sender-Id: techassets|x-authuser|kishpatrick8@ingodihop.com
X-MC-Relay: Junk
X-MailChannels-SenderId: techassets|x-authuser|kishpatrick8@ingodihop.com
X-MailChannels-Auth-Id: techassets
X-Whispering-Arithmetic: 3ce9cd084db26345_1663320902497_1846147484
X-MC-Loop-Signature: 1663320902497:1605829174
X-MC-Ingress-Time: 1663320902496
Received: from vmcp128.myhostcenter.com (vmcp128.myhostcenter.com
 [66.84.29.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.126.240.206 (trex/6.7.1);
        Fri, 16 Sep 2022 09:35:02 +0000
Received: from [::1] (port=59444 helo=vmcp128.myhostcenter.com)
        by vmcp128.myhostcenter.com with esmtpa (Exim 4.95)
        (envelope-from <kishpatrick8@ingodihop.com>)
        id 1oZ7k1-00Gm3w-4k;
        Fri, 16 Sep 2022 05:34:32 -0400
MIME-Version: 1.0
Date:   Fri, 16 Sep 2022 05:34:15 -0400
From:   "MRS. KISH PATRICK" <kishpatrick8@ingodihop.com>
To:     undisclosed-recipients:;
Subject: Contact
Reply-To: mrs.kishpatrick2014@outlook.com
Mail-Reply-To: mrs.kishpatrick2014@outlook.com
User-Agent: Roundcube Webmail/1.5.2
Message-ID: <d1ad8d848d6b6c0b357ee70fdacbfbdc@ingodihop.com>
X-Sender: kishpatrick8@ingodihop.com
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AuthUser: kishpatrick8@ingodihop.com
X-Originating-IP: ::1
X-Spam-Status: Yes, score=7.9 required=5.0 tests=BAYES_50,
        FREEMAIL_FORGED_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,HK_NAME_MR_MRS,
        ODD_FREEM_REPTO,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  1.3 RCVD_IN_BL_SPAMCOP_NET RBL: Received via a relay in
        *      bl.spamcop.net
        *      [Blocked - see <https://www.spamcop.net/bl.shtml?23.83.212.26>]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 T_SPF_PERMERROR SPF: test of record failed (permerror)
        * -0.0 RCVD_IN_MSPIKE_H2 RBL: Average reputation (+2)
        *      [23.83.212.26 listed in wl.mailspike.net]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrs.kishpatrick2014[at]outlook.com]
        *  1.0 HK_NAME_MR_MRS No description available.
        *  2.4 ODD_FREEM_REPTO Has unusual reply-to header
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



-- 
Dear Friend,
It’s just my urgent need for foreign partner that made me to contact
you via your email. The details will send to you as soon as i heard from
you.
Mrs. Kish Patrick
