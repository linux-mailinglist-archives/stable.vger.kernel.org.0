Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7FD5573FE8
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 01:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiGMXCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 19:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiGMXCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 19:02:36 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FD92B256
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 16:02:36 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id n74so372278yba.3
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 16:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=MRsoPI4QViAMcl9XohHy7taHIEN8NOB/plAqvg6094tVTk+Y/Ehjr+R+x7jt8QoZyR
         taODxBhrDF64IpdYBy/3usF8n7mJEKv8rLDPINhe/q49K14IeEDvnmTmNgZQzSdA1ER5
         4n4MP2Rx3N+2VFnZA10IOmEuNz6ZsWhDL3X63rKvy+KeUrgRAV/1wNWiTz9Rj6PqmLLZ
         uQrzrjh52YAkvY/biohrnshOHKNhdoKFg5sOoxcXP/rXGEoWvhgWph+NUbu5i243J70A
         cZuKVm5pV6cTpy0O7oqgMuHsd7MCnUtdQOWnfujU2Z8xONaHaqf/hPqxrLncO2ZPkbRN
         N47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=OOVZZT6bVgAzKXFyeVLvnhBpaVP4qKzEFlMM4qtESwo6h+H7UKGiQqphIGgKFL7/al
         9E5JIBJokw4253SPYwA06l++k1EM1p2bSQSI/GVguC5EnpugpN3rp5zoSsM4f88blm/h
         IAiAx+2aO6cqR2KZ7Q2JqUL6mAAL2Il8bINwlMLpeBE3KNivo1SPm+ddkgLhCzsBBLD1
         xMgOj+dgIaO5dIoWxuNccVqM0ofMQUd3qS7WshiePgsYuZuqFQCOBO61xq4T6BZYK6kE
         mKLs74yj5iopKw1ft+cl2e59KcjLLuW0RPI5GBkOJptfvYvmVisl6FcJ3BLDaEXa9R9x
         h8Lw==
X-Gm-Message-State: AJIora9WDWHwspFfDe9HPQo6GdNGsrbSOHBu2EgwKYARdtM5EK4MKWVN
        t6bCVDvCUyQid+4tCBi2qTMeCZgfUDBKfNzFVdU=
X-Google-Smtp-Source: AGRyM1tz0RXKq67AFI5BivHL0vWsYQ+wpNeSEOqb4cWqaxCS3aMTSAnpWdQ0G3Ln2FUt1SOLnLr3CbXbiMVtQyb3M3c=
X-Received: by 2002:a25:d717:0:b0:66e:23cf:7f95 with SMTP id
 o23-20020a25d717000000b0066e23cf7f95mr5630234ybg.605.1657753355153; Wed, 13
 Jul 2022 16:02:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:764f:b0:2e8:3dd3:acda with HTTP; Wed, 13 Jul 2022
 16:02:34 -0700 (PDT)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <gracebanneth@gmail.com>
Date:   Wed, 13 Jul 2022 16:02:34 -0700
Message-ID: <CABo=7A0bVduxit51p42b7URBGV6HFNC8HvWq1a3unw3CMP0q8g@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b2e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5053]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [gracebanneth[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
