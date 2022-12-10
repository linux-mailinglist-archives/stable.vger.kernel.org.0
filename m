Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A04649021
	for <lists+stable@lfdr.de>; Sat, 10 Dec 2022 19:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiLJSRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Dec 2022 13:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLJSRv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Dec 2022 13:17:51 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D379613E01
        for <stable@vger.kernel.org>; Sat, 10 Dec 2022 10:17:49 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id b2so18649084eja.7
        for <stable@vger.kernel.org>; Sat, 10 Dec 2022 10:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p5QvcOSTf9BtV2gQoSgoImCpAfNLsCv1hbQxJ4JQXgE=;
        b=lRGDqN3dJ61yqWC62dRK6nniWq+YnvxkEGsg1jXiPWMHlRXKh7IvOVHVf5xH7zKQ5I
         +7Pk8N8vhBXSG8+LegmTYGCWfTwxQNXp2xI9MvopeqAx3vgvz0P3xST4MSghJ9fwxjOE
         NwPlo8AFW8fQoyC3s74CE8ZqV9gslPaxVbiQAxKScjdEZ1cr2KnJprGCG+cNYS1En64E
         WzhYRC8+wdsp7vVMynLzRIrGUh0noZmLo4lPgZXqonEKnwHoj3zxFIvkSzfDJWP6lJDd
         8WTKJPvfQPRW9Y7P/90mbEbtoPBQMciilQx+pHMkQ5mmy6fQzlmnuA/E4z4+qDBpAmtd
         L48A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p5QvcOSTf9BtV2gQoSgoImCpAfNLsCv1hbQxJ4JQXgE=;
        b=YgqmEbdxRjqeiSpPtCjAyHtsM1J1GkPIi4nQy1DOnFkR8uLTihX6QZf0eWJYnrW8Lq
         x6g48MWtuEtAH6c9tSp6fadGn5ENr+SDfiIonqMlDIwIPjoW2fhnSmrjv+cNsHennTRF
         O2p1UCl7ZfJJGLjFj0XbBT2JOe+FObLnTf26GKE9Ta4/O3NBJvjsp/fIp3txC57uzwFZ
         lAMro9vfx8rraVY+O7jnWD8EYLw67dXQDfo20Wkvk5eDhdREA5wR3FqBs27x8MMIJE09
         MZL8dqL5ow+MAwAHcXCcjLUcFFd4N7dNhmw/OtPsdSjOcQMiu1ZR20ZAolFm408o+ol8
         rFsA==
X-Gm-Message-State: ANoB5plbLB4Zjh+66zfb873WWWv/FAvJhhYr7qarQPf6fO5PhoYGCqyo
        GIk0Kmk88nKvdO/kvcFFjiKYfxJbRNBK+YJI4Ew=
X-Google-Smtp-Source: AA0mqf6zdz0UP8il+AbwTJUXbOrM2kzINSRc4i9fGW9K6BgGh3Wb/pcyRs53aObxzLMXladfItJBsvgch2jNEzGXd6Q=
X-Received: by 2002:a17:906:95c3:b0:78e:975:5e8 with SMTP id
 n3-20020a17090695c300b0078e097505e8mr63714145ejy.82.1670696268318; Sat, 10
 Dec 2022 10:17:48 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6f02:858f:b0:27:9271:bcb7 with HTTP; Sat, 10 Dec 2022
 10:17:47 -0800 (PST)
Reply-To: felixdouglas212@gmail.com
From:   "Douglas Felix." <legalrightschambersfb@gmail.com>
Date:   Sat, 10 Dec 2022 18:17:47 +0000
Message-ID: <CAEERoqgNdGfUTeTcOeDNGRFhw5gddVo+xR8x7oSOPYgPLV2-Pg@mail.gmail.com>
Subject: =?UTF-8?B?44GK44Gv44KI44GG44GU44GW44GE44G+44GZ?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=7.6 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:62c listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [felixdouglas212[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [legalrightschambersfb[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  2.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LS0gDQrlhYjpgLHjga7jganjgZPjgYvjgafjg6Hjg7zjg6vjgYzjgYLjgarjgZ/jgavpgIHjgonj
gozjgb7jgZfjgZ/jgIINCuOBguOBquOBn+OBi+OCiei/lOS/oeODoeODvOODq+OBjOOBguOCiuOB
vuOBmeOBjOOAgempmuOBhOOBn+OBk+OBqOOBq+OAgeOBguOBquOBn+OBr+OCj+OBluOCj+OBlui/
lOS/oeOBl+OBvuOBm+OCk+OBp+OBl+OBn+OAgg0K6Kmz57Sw44Gq6Kqs5piO44Gr44Gk44GE44Gm
44Gv44CB6Kaq5YiH44Gr6L+U5L+h44GX44Gm44GP44Gg44GV44GE44CCDQoNCueym+eZveOAgQ0K
5rOV5bu35byB6K235aOr44CCIOODgOOCsOODqeOCueODu+ODleOCp+ODquODg+OCr+OCueOAgg0K
