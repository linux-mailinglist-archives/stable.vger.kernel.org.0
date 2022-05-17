Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4BD529DB4
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 11:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbiEQJQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 05:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244475AbiEQJPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 05:15:54 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3874310
        for <stable@vger.kernel.org>; Tue, 17 May 2022 02:15:51 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id l18so33401625ejc.7
        for <stable@vger.kernel.org>; Tue, 17 May 2022 02:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=SUWQMmwZSct1NUq5pHL/uGOr0m/f9iWjJQkP63QJuAY=;
        b=pKZ2oEBEivZXg5SRm1le5ilKqIF28w/182PIR1Fz5vwiOrcJ7BNxc/qbaHjKSvDk65
         DGzKsWcM+yw4EFW0Mt/uX6cjMbIHUrBi5yZSaaUnNtKmicaA0SbNQsfIJBN3nG1x60VZ
         c5PmpBwKKK02ChpMKnFWkd0eHzXQ+CK2LnxcrZRaEVNwYs3ksYX+xQd2CakO2W2CS//p
         K9kzwlZ9GetpNEdfthMPp0ujcBALfvlN5VPkDjYrbSiaSwl3pLExumJ+oWhyUY/4T1f/
         0JkG1sZmNysBQTK/kpCDggXHXelUjWqNzvewpAJlDTz1+IXYFbNAc9Q5lpO/2m2is5p8
         SSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=SUWQMmwZSct1NUq5pHL/uGOr0m/f9iWjJQkP63QJuAY=;
        b=ZV/l116lICyuLJPgIc/lOyUXm0QWnhDud6kTmg5qQuDCpPmrI6O9cD/L6TjcTOk1AL
         6yfUSsNus/ccXNNYoyJl2ueRdM3fFPg0kHME2J3cp+OKF7yL3svbfx9H3cB7OqhUAYUO
         RgDtnrBj28K70OWRly1BKc1DeZQqRBDjL+fmkOwmN10JaYlM7i6vpw08b5PqUKkAqpon
         9PtZi4jXwl+rnLAFwSuiDvFLljhc4UU5u6+N4i8zJG9ZUmbYoKMvpW0QE4qd5UjZyYFT
         lrwD0BTIqyycVVbzlh+YC0IMFYicyss4WRGdeyZ7RkxiPgTqHTOqeMYubEa3j6ZpU1ui
         R1Sg==
X-Gm-Message-State: AOAM533JWo6MIvrWECFH966O9Jh5wEXGn9tyxZ4HgOjfKmyh+2RlA06u
        YFMkEzLyPfig1UJc5uC1qMZZfWzbWsBplYg5Mfp9Q4qv0Ceh/g==
X-Google-Smtp-Source: ABdhPJxbqaOfB2fJUrm1D1MeQ674vamuVnWg6qfBf5HgJTdr8tOEIaJO6nTl+XQk4Ui0JJep/NQLoJ5kIuxJTD3ZHy0=
X-Received: by 2002:a17:907:961b:b0:6f8:8b28:f2e8 with SMTP id
 gb27-20020a170907961b00b006f88b28f2e8mr18758348ejc.76.1652778949843; Tue, 17
 May 2022 02:15:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab4:924a:0:0:0:0:0 with HTTP; Tue, 17 May 2022 02:15:49
 -0700 (PDT)
Reply-To: jub47823@gmail.com
From:   Julian Bikram <kodjoadannou123@gmail.com>
Date:   Tue, 17 May 2022 09:15:49 +0000
Message-ID: <CAOtKoZ-uXnOLoFsesrv=iNnZ6wTbRHMLcwoZFF-p9-0+KfpxTA@mail.gmail.com>
Subject: Please can i have your attention
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4993]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [kodjoadannou123[at]gmail.com]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:629 listed in]
        [list.dnswl.org]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [kodjoadannou123[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jub47823[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear ,


Please can I have your attention and possibly help me for humanity's
sake please. I am writing this message with a heavy heart filled with
sorrows and sadness.

Please if you can respond, i have an issue that i will be most
grateful if you could help me deal with it please.

Julian
