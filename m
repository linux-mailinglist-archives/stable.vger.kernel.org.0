Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09D969B1DD
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 18:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjBQRgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 12:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjBQRgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 12:36:11 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888B57293C
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 09:36:08 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id g8so1495025ybe.13
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 09:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ku6/IvgVl/mpN7kpsosgj0Y3GnwtptLKAhd4JFHSZ8g=;
        b=gA3Vo47kBgMkp63vwjyGjDSfUXvyC7jMfqwFXRuWmDS5RhLk6ozwn++tCLjV9NAHa4
         oIegtdT7w/VODljeNLfZRPl0ICQgdau9r9xblUo3C3H0D7S039lMu31PWXbN68iqCkrI
         cMHDQe2vSFpjiykV9dy/HiXMv1NxrvV7PXrbLXNJCsy0OLxPgA2M/iBLR63fHELEms2C
         r9oiDTBK7pDOJNGQXuKC69gyHhQLalorwCqD8GCSotapjknBzxTCi4BIbWwKw+bNVHkc
         VVo8LFNAsYKHH7ZWsgrg/GIXCNaCMLJJaggl9aIh0vaogpLsSsl8osF7K6tzt6OOPZx5
         0OzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ku6/IvgVl/mpN7kpsosgj0Y3GnwtptLKAhd4JFHSZ8g=;
        b=wciNKVrHeU+7URSzFMGkOYZzCc8IDPS9u+Eoeecf6/P6hGXT0rqpfQq5nM9tPvWpQw
         q2HkDB3k5ftmO0WsoC9omrLJ2CCdd48s/wR7++WBTnpUfk9p+MGrjpvDNqbfomiCrEhk
         uLdfxq9A5FJzC85iJmy4Eo2yjA60VhVsi0LuaB6x2BLPq+O1ftMm1lenJGXpEkgIF9jU
         o7ArJTCrT1MAn6jq29c9CTXElFZn/fyxnxxscKFReR+NyyvIIvp+Xv1TJrdoE6/praIN
         EEs9nk8X7yVpjUlqq9LXg5lpVTPtwm539gb9RnxMDqKj+jMh/Jn0bP2oijjzaoc5Q+LV
         E4Qg==
X-Gm-Message-State: AO0yUKXhWdNRqaWrXzYWetDC/gtLyHhN2a0GWzD5AFWM1sGd6hJI6iGY
        2NMIerjDtH4J4hXU11ND6iFMuZa6OS/Dl8soPos=
X-Google-Smtp-Source: AK7set9N8jTjbboiSGFBQGA0fOm74Slyi8gImBzHJ5lbI2wjXuaI2oJb3pk200AIIvLsuYZJ0vnWLfovUwTUyzauueM=
X-Received: by 2002:a5b:f88:0:b0:965:3b30:f442 with SMTP id
 q8-20020a5b0f88000000b009653b30f442mr659437ybh.326.1676655367727; Fri, 17 Feb
 2023 09:36:07 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:548b:b0:1a2:d75a:aa76 with HTTP; Fri, 17 Feb 2023
 09:36:07 -0800 (PST)
Reply-To: wijh555@gmail.com
From:   "Dr. Young Sook" <ysook9039@gmail.com>
Date:   Fri, 17 Feb 2023 09:36:07 -0800
Message-ID: <CAJSoACPU6R5A1e9xoto8muwBpwOG=7pR0fjeOK7LW_eOpJNfug@mail.gmail.com>
Subject: Very Urgent,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b42 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5015]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [wijh555[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ysook9039[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ysook9039[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello,
I tried e-mailing you more than twice but my email bounced back
failure, Note this, soonest you receive this email revert to me before
I deliver the message it's importunate, pressing, crucial. Await your
response.

Thanks,
Dr. Young Sook
