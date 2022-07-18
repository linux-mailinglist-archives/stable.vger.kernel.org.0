Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9AF578B49
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 21:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbiGRTzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 15:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235979AbiGRTzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 15:55:33 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B7E2B250
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 12:55:33 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id 64so22791622ybt.12
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 12:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=h0ZslgqQ94UM3iGDYCZGEx8ZwvbYHY5ZrQARiO/Kpbc=;
        b=HVCuRE4RG/5rXdX9sRHb8ZQTO0ahmYn3w3CtJkCzHjdqDZj8+W9wTXDUUeoZd9AtYK
         l9kScs2tNMCQgQnLi1gjGoIjWr+UPpC9rrXov6aS48NTSA8cnPTe1wPJ0weACG4JGxOL
         ULcFs4A3ymCNMRrpipIPQVRT7MbXOJZRMClTpmAzPzKjJsA7gxZqCRiLdqZcGEzHI7+R
         n1cQkHjFThVaJJeMhAYusCAxc6XUVyAYC+HgDhveAkx3g2+x9kUM3Z+sk14rHXEc3762
         CkPkvI46UaD7RwoPFJTekVFnsAscZnTYrYqh5LKeY6pJzAQsrq8tYM4sKepRGvNkZubG
         ZVBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=h0ZslgqQ94UM3iGDYCZGEx8ZwvbYHY5ZrQARiO/Kpbc=;
        b=j0z+7AF0skKg67Yb/bL4pK8dwFs3v4IztGZHuEuj28WuUm8Quh2vdnFhtiqhD/pVA+
         fRxqxHZRXEnjfJ6P5lwBXuqXfox0TwRjHHdwT5gJq8nJ1tfj9xCOE2OV2v0wZ9esnslu
         NajN9pOdtPhpfnXumP3z7bOR8+zjJjhB0Qi190+qQ4EtuH8N1WHVEyRWzOdim4zCY7Rg
         xBCsEzYdYYCnXQr9SV+Cj5eaFeY/bnlEDsfTDFZ2Xz/tqoWerJP5J6TBmJZNh52GnHRQ
         ogSbsMk+R3BgENK8nJVKICvANeDfGz2/q5zQqpoC/3xSPztInLyPwMuU8w7r+tl2qrKf
         D68g==
X-Gm-Message-State: AJIora9I7uHiG5NK78hRJZgN5xpF1MFA3S265s6hnL/+6gHOLcf9DFXy
        f6DzTk2NCyywh11esPPtWo1U2l3KUKIpP0AF4mI=
X-Google-Smtp-Source: AGRyM1sIKZGV8rKedeSqneamIEQqdvwJKdkVHr9z2pmJPThkmncgRFY8wX7Q5BbTOQrK0bPbiTRpEEVlxC6DCsLsGgA=
X-Received: by 2002:a25:d94f:0:b0:66e:626f:7786 with SMTP id
 q76-20020a25d94f000000b0066e626f7786mr27145212ybg.426.1658174132233; Mon, 18
 Jul 2022 12:55:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:34dd:0:0:0:0 with HTTP; Mon, 18 Jul 2022 12:55:31
 -0700 (PDT)
Reply-To: lilywilliam989@gmail.com
From:   Lily William <rayimemogn@gmail.com>
Date:   Mon, 18 Jul 2022 11:55:31 -0800
Message-ID: <CAMefwTOQmVXjb44T7OnN_ndTQV77_1EGnGDmW6bYhR34jKRNrw@mail.gmail.com>
Subject: Hi Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dear,

My name is Dr Lily William from the United States.I am a French and
American nationality (dual) living in the U.S and sometimes in France
for Work Purpose.

I hope you consider my friend request. I will share some of my pics
and more details about myself when I get your response.

Thanks

With love
Lily
