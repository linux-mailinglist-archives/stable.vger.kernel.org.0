Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537DC63A629
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 11:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiK1KeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 05:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbiK1Kdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 05:33:38 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FDD1AF00
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 02:33:32 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id e24so3674430uam.10
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 02:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JFV+j+1TLtUL/wbZKnobmQuBkAthMS/vMODiYSi4VWQ=;
        b=dN0S/TpVo17Z4AnM/TuuJaCe98CuqanwOg5YHhJKFqDRe/XXHVEJsjoISyq1Cmqx1j
         0uBLi5k2KYgKLb0wJN/8nJMKKC+QfAoQMBUXlp2twX/+qKIPRcED3KeU8t5ehnzJFS8T
         65TGWtyTWNeKESVAV5k2Jq8+UbUBXufpB3EU0Q/KtwpV+2ospxwEbNgud4LgaQwoYPey
         U9Ic8CybTRvL7HXiy/aZ4Uq3ljQIVGFP29Etd4oyUghXDNW7Hu4mQnhcWAgztWv/eah+
         mY/j/CvhNH+RCzVLZwBf/PLZqJpBKhX9wvmc8it2YhsMYfHMSiuTDN3QWe5hGOQLRL7Q
         lJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JFV+j+1TLtUL/wbZKnobmQuBkAthMS/vMODiYSi4VWQ=;
        b=qs5eZyvFUOhKDscKcZQKF1RZwxHzJbevfRcbEG0JJKEi4lwHWDlKizdBFDBpxXpFTX
         YOuwKTHncJBxrHdZbzwe0nxSKINC47gJBRTzfh779ZvSx4SgLoiTp/2yyjHuhCMwQMig
         Dm4F1oeqRkWTw4qTakziTyUbjZy4YDeA80KPoRuhtRKIE53629qOByPseNcD+qOChfEK
         n6UeBqSqPhMSHpY9BGJJXZuiAC7FCkKeNnolHnUPIHlwnCuXy4QJSOIzK/9xXuUmnSWT
         1qG7gfyapFX2em6ysd0nBUm28tVQN71llElQB7AU8bMCZOSywMwuwcy56qqZqTdI3Yq+
         jozw==
X-Gm-Message-State: ANoB5pkna5DY6cdwe9ifzIk4pYdRviy1+YGKOiva7aZD8KTSgdLiE54a
        P2resGEMM6odwcbyL/L9tlkNsDvwPghmGE1YyLk=
X-Google-Smtp-Source: AA0mqf4b8T+FeAOE8Bo4igruw+OZCvIu8xtSfd4uYD/tTavKK1ginA1t4eiN7UHcz3azfmiwSNHAhXhkqn+zJSTyc5A=
X-Received: by 2002:ab0:298e:0:b0:419:27e4:c2b9 with SMTP id
 u14-20020ab0298e000000b0041927e4c2b9mr416176uap.118.1669631611164; Mon, 28
 Nov 2022 02:33:31 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:dc91:0:b0:32b:a013:5722 with HTTP; Mon, 28 Nov 2022
 02:33:30 -0800 (PST)
Reply-To: erickkofa@yahoo.com
From:   "Erick Koffa." <koffamorris8@gmail.com>
Date:   Mon, 28 Nov 2022 11:33:30 +0100
Message-ID: <CABirKWt9t3zBC7GeQJezLVXUvYi+MEYPfxWBi0GfXQ2kR1fX=Q@mail.gmail.com>
Subject: Re:
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings from Mr.Erick Koffa, can i talk to you, very important please?
(erickkofa@yahoo.com)
