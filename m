Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DED35B4CFB
	for <lists+stable@lfdr.de>; Sun, 11 Sep 2022 11:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiIKJZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Sep 2022 05:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiIKJZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Sep 2022 05:25:24 -0400
Received: from burlywood.elm.relay.mailchannels.net (burlywood.elm.relay.mailchannels.net [23.83.212.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736BB1A83F
        for <stable@vger.kernel.org>; Sun, 11 Sep 2022 02:25:23 -0700 (PDT)
X-Sender-Id: techassets|x-authuser|leesusan12@ingodihop.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id BEE2122677;
        Sun, 11 Sep 2022 09:25:22 +0000 (UTC)
Received: from vmcp128.myhostcenter.com (unknown [127.0.0.6])
        (Authenticated sender: techassets)
        by relay.mailchannels.net (Postfix) with ESMTPA id D610522673;
        Sun, 11 Sep 2022 09:25:12 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1662888322; a=rsa-sha256;
        cv=none;
        b=YdwyUBxDVqYcCMGXUW4mitosPyXsX5QINUUWv2i9qORcVdPhjOOAfdqAgu9zu2pkEKhA+X
        Fni4yepx8HEW4rzLVGdTaVR1VNZPoZZtNW9zhtF8QwbwaM9WN6Zevcm/17kwYPIlQ6SA4j
        WxesmY5tQKdOMyk/GkbWGNIwX3QzEWnyD/OrRTu2lZjiqVGwQCLi2SqxHOpUnL6wwQzlB1
        +wLxDUaOAjPpBh1jVceqIPhYp91RAy0mXOCO5PYM8QyOORnTVU0y7j2eNNZLAbPjc5cp3K
        GtSmtbFY6bwA/FssCdbrsgygsCPuy+quT0SCNpT9KqQdXXRSWF7M+wLtEaKjPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1662888322;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hXLnhYIY6RPq2jPDah+snLlNw2/6UxQIEbgnwiMYIN0=;
        b=xuKS6zmkS1vcYIvs4M7BTp6JhW1x6xAJKUd3G677p3EjXFVsP7MFZwEozvYSlYeLrhXo+W
        iXjqXaXtyIYTHjzDMOaSlsDfUNuNqyTTizXs2ZO0guuPE1yWeeytQ4RRdWBWnZdxm1k5Sx
        TGPJpbLL0Qv0u1IzfXEuB4ccmecW+0if7YdwJc5NN8aHfJ4bCi1nQ9VLwX2OVb49dyFKRx
        fRongIvZz9XCgLQO8749bXAamUA5PYmiBqxmwXgg27TzLa04l4d0pJKzWiiBqvxxlkotl5
        cGq597lPvoZRF7wQ71ergzRX/Tq5lA+V9AqZ+HpP1BslrsPUxoAar0c5tlbF5w==
ARC-Authentication-Results: i=1;
        rspamd-686945db84-vggvj;
        auth=pass smtp.auth=techassets smtp.mailfrom=leesusan12@ingodihop.com
X-Sender-Id: techassets|x-authuser|leesusan12@ingodihop.com
X-MC-Relay: Junk
X-MailChannels-SenderId: techassets|x-authuser|leesusan12@ingodihop.com
X-MailChannels-Auth-Id: techassets
X-Whistle-Tank: 0aa57b3166b4755f_1662888322506_1376925549
X-MC-Loop-Signature: 1662888322506:1861067359
X-MC-Ingress-Time: 1662888322506
Received: from vmcp128.myhostcenter.com (vmcp128.myhostcenter.com
 [66.84.29.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.108.161.89 (trex/6.7.1);
        Sun, 11 Sep 2022 09:25:22 +0000
Received: from [::1] (port=55714 helo=vmcp128.myhostcenter.com)
        by vmcp128.myhostcenter.com with esmtpa (Exim 4.95)
        (envelope-from <leesusan12@ingodihop.com>)
        id 1oXJD2-009vuY-2k;
        Sun, 11 Sep 2022 05:25:00 -0400
MIME-Version: 1.0
Date:   Sun, 11 Sep 2022 05:24:48 -0400
From:   "Mrs. Susan Lee Yu-Chen " <leesusan12@ingodihop.com>
To:     undisclosed-recipients:;
Subject: Mrs. Susan Lee Yu-Chen
Reply-To: mrs.susanlee22@gmail.com
Mail-Reply-To: mrs.susanlee22@gmail.com
User-Agent: Roundcube Webmail/1.5.2
Message-ID: <063b0863ceedb13f46af4fd403fb60cd@ingodihop.com>
X-Sender: leesusan12@ingodihop.com
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AuthUser: leesusan12@ingodihop.com
X-Originating-IP: ::1
X-Spam-Status: Yes, score=6.9 required=5.0 tests=BAYES_50,
        FREEMAIL_FORGED_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,HK_NAME_MR_MRS,
        ODD_FREEM_REPTO,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 RCVD_IN_MSPIKE_H2 RBL: Average reputation (+2)
        *      [23.83.212.26 listed in wl.mailspike.net]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrs.susanlee22[at]gmail.com]
        *  0.0 T_SPF_PERMERROR SPF: test of record failed (permerror)
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  2.7 ODD_FREEM_REPTO Has unusual reply-to header
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
Dear Friend,
  It’s just my urgent need for foreign partner that made me to contact 
you via your email. The details will send to you as soon as i heard from 
you.
Mrs. Susan Lee Yu-Chen
