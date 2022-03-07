Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DC74CFB40
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbiCGKd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241986AbiCGKbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:31:20 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3848E63BCD
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 02:03:02 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id qx21so30628108ejb.13
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 02:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=t6DcQhfFfmQsTksI9MS4VLvsVDH6vcj7lwbO1DMdjXk=;
        b=ghh7IBe0OlKMD8cnMeL5PUNvlM35Umul4FpFZ+kLIg8QPT4mrFLChPm39elXDFjUKQ
         o9nOPvK5dSAodHFy/MUZduJ6AKvlAEqaFgTPkssqH18lf+2H/SVvFxdNZcgA92QSdXbI
         xyb58FbBxKpO1MXihUYJ4Xo7MBzN7mqhfMESAAgMiH4T/UKw76xJl9362jHwgHQ0jQzh
         GL4tHijTpryvsQR3vteFoqBQR58C3AJidpKXVYXPnH5K5z5tQVoXggaETIIoZ4TuRTSi
         xIkrf4x/XmAoXWnG6wZ9kAJfprK9P97xT7PYOjisUH34FBGRsURwchj42QO3IQ1d6Sxb
         MLYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=t6DcQhfFfmQsTksI9MS4VLvsVDH6vcj7lwbO1DMdjXk=;
        b=bCECgx9RbTP1BBnqKCCSIEHboHn26frSnr/zlKv/ZY8+XXWGyGqTc1Qb4vwAKJo+3w
         Q0uhCxXaxsga8Cu2c7saPtPgOLXZNH8HccroLlG9plBi8MZSENcnxY3b6xtydwpcxvNB
         s6GmXlNsZRPfMiIv4tGYiAYTMylrj8RY4VgmU/pt8pVl+IzW/sht6sQFydmA+g8Pl3lR
         JCHEeHO2qY1iOXZWXUjF4Tes/71FPhE5g4RfpqWeMS4Kwt3KJxIShr8pWeC20El62tSh
         9Od1/NKsKYYNMO2YMp78lilLcjxqXCyeV6x3aBl1UPiiOqBlSQc2V+QoDak4dm1oYpp7
         V3sA==
X-Gm-Message-State: AOAM5324Vm/A+6lDz4l/mJeIaOb/vvX+DK4iyWAdWfehlgghc2pOVYNA
        +j/Ceo0UcwnjDKGXg8HPRG7B0vul2SjsMQ5I1Es=
X-Google-Smtp-Source: ABdhPJxTgNbPYAy0UfOLlA2+GgVo/q1+95vfDim+SgLhMF38YB3TW6Rr9gtRcFBAzWDoksaB7W8nJd857elnuBsWGvk=
X-Received: by 2002:a17:906:9ad4:b0:6d6:e972:a9e9 with SMTP id
 ah20-20020a1709069ad400b006d6e972a9e9mr8374635ejc.669.1646647380154; Mon, 07
 Mar 2022 02:03:00 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:907:2d20:b0:6da:73ad:bd17 with HTTP; Mon, 7 Mar 2022
 02:02:59 -0800 (PST)
Reply-To: brookw094@gmail.com
From:   William Brooks <businessoffer11@gmail.com>
Date:   Mon, 7 Mar 2022 23:02:59 +1300
Message-ID: <CAH35tw2mdrt8ni2=CmPEmmNn1rW_F_0JAj1NJ05a86n1GB6a5Q@mail.gmail.com>
Subject: Your Attention is needed
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:62f listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4854]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [businessoffer11[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [brookw094[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [businessoffer11[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hi,

I am a banker working with one of the leading banks here in the United
States. I write to contact you over a very important  business
transaction which will be in our interest and of huge benefit to both
parties. Kindly get back to me for more details.

Thanks.
Mr. William Brook
