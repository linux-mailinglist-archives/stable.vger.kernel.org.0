Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523BB51DFE0
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 22:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392433AbiEFUEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 16:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392440AbiEFUEp (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 6 May 2022 16:04:45 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835A15F8C3
        for <Stable@vger.kernel.org>; Fri,  6 May 2022 13:01:01 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id e2so11311534wrh.7
        for <Stable@vger.kernel.org>; Fri, 06 May 2022 13:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=C+z24Pl7od6xO10XmMEfecsYemTIfW+XARlPRi62dVY=;
        b=oRJ6m/OLLZY9sBG9HJX+g1ZI/1BJXQmkH9lUELt4EQyUlQERzEWur4NVUloIKfqSbh
         0O+ZjrKZ9HKU0j1E+srywTecHth5WgKKSBFFcVazwc/6nTqkgWZb4bgRJrJAn8xrEbWs
         5LD5qrgKiZTWKPMYgrzUmHKxZmBoh8aUfjmTpo96KUMPeV87SQUid/VxfRWzJ/lQ/qPo
         8xvcXz4hUa+UjmkhYG7deQLFEn3VVJeu6oLogUZyaXimBF7rJz7OKTcuC3cUJzcFE+Bd
         ZjqcDsY7n5MmBrQPnxc8ck4s0zVbT+Dpfk8x+LuH3a6DK841uHLCRYWyoOFF0jKwMSLH
         SdzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=C+z24Pl7od6xO10XmMEfecsYemTIfW+XARlPRi62dVY=;
        b=c1u/W5zOVfPR1rN9qaJ2Zz/R7NvCMp6Cll99pDA2Y38wkWpoJ3Ft9zIriabsvdCLF4
         Qk6rwUZlapTwSpvJLE5d+z2z+HL4zi9Vz2JOKX2Sm7IGXuvAPON1iIOd+ya29IeMvJ4j
         PsXqPJ3Px//V7MnZ46yr+XUKOwnmJ4uvcqXl1BmJKJoZmhDDjadffHR0IZLNXqLrKMwj
         IJVS+S8fDbloZkUI/M+zCO6UXiVQQj9WfFeXvl0EAJSgq9c+IvR8/BkfSqG/FdPOUzPr
         cjsYQcFSBrS2hdN8at34XSsa92uWQz8jMD7q5cd5RcHMP7TpHQ8pFoANZtCkB4tPkQPP
         5DwA==
X-Gm-Message-State: AOAM531DHu9BY36R7/A7PdogDTzzFUNNFMhQjlpVrD3y/G/EYBT+8fzW
        Ny1xgEdwt78cavm2JO56yZ7hLYfProm/1V+yk50=
X-Google-Smtp-Source: ABdhPJwoF0w1HUVD7u7LtsKAA46BnRn4YmA1dd5GOBN8/SJTvHqLqq+Y6Klqw3ecW4JGa0+na9i8D8YWTAkikYfLtug=
X-Received: by 2002:a5d:5692:0:b0:20a:c713:f448 with SMTP id
 f18-20020a5d5692000000b0020ac713f448mr3913101wrv.416.1651867259658; Fri, 06
 May 2022 13:00:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:1f1b:0:0:0:0 with HTTP; Fri, 6 May 2022 13:00:58
 -0700 (PDT)
Reply-To: paulmichael7707@gmail.com
From:   paul michael <gabrielbenjamin299@gmail.com>
Date:   Fri, 6 May 2022 21:00:58 +0100
Message-ID: <CAHdQu5bxFZ7HLtdiK9nLTtoccJKZsGd4fQ2wqu=1KocVok6mXA@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Every time I retest your email, it tells me to check with my ISP or
Log onto incoming mail server (POP3): Your e-mail server rejected .
Kindly verify if your email is still valid for us to talk.
