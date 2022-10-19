Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40BC604E7B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 19:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiJSRUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 13:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiJSRUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 13:20:03 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C40FAE218;
        Wed, 19 Oct 2022 10:20:01 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id be13so13627763lfb.4;
        Wed, 19 Oct 2022 10:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=CXA2LiAO7u/GJC2KI+wrVkIBZAgOhar/ztDS86G5QbeerMWCPrvTddIKEvH45b4MFW
         4V2L+QlAkRWG7gl5GqDBFRL/ZPoa0QPwjsfCN+/QqUWu775mVYjaL7uh09McG3RnYWKp
         ZRbYOCvbKU6n8wPzUKfyE/aGfffjU4TAT7BGJN/rWmdB1g7WBzgrR3YG97swMpC4kekN
         /ONy+wfB1GOGPWWLc84/YgvEZQNRHSYyiubKp2+QnBWtB3y+4BxYNKjD4z3Y52Dyxr5v
         Ma/1AekLrY+OUudCHPQihTIwiwV1h8TEuvl3O0al09A56xwZYtkrZKkX0Ij+04/ValkA
         rKSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=c2/hvvT1H37NiGSzLdiiIZBSKxvZExVfal9v2Ml4KQCsHTDAR2+mwYiUwlA5zHPKHR
         yDUxJHvmryJ6tygyzdstV6l9VMyUyb/ua8VBHD4/f0qQrQpllLHLXa+taaDHH0y5oKl9
         tRxt/KftKXhPYWVPEk0wqyJ8YxijmgpNTE89YqokJRTAuprQDuuinSa0g606dhgrkSIm
         v8wg+M7XFZ+7RIMDxuiYB14m29ROJVIIUZdsXP2xIo8R5TILZXvSrXy/UhOE7p7jTJ7E
         95ziwWdTtfaULyNgZfVT+qm/OPfXLyUyPuTGdtpmb8FGVH7tTa7UwMqaSqoUICOqmQYq
         rVxg==
X-Gm-Message-State: ACrzQf2L3a/aAYLBKSjl9GHF9vmqJTgOS2h8Cs7BjIfxzI7H1s93e2Lf
        B9HJKCxBB3lN8sEn7/SN5TgXKCAECN6tClrVUZcLXsDbYUc=
X-Google-Smtp-Source: AMsMyM62045Lg8CCPmQYDiwsb0U64idb400UREru6gqFm8/5GJKibfOSbQpimza3i/qw/IqvrSvJ7BZa8OUE3Od4YBY=
X-Received: by 2002:a05:6512:acb:b0:4a2:500f:af73 with SMTP id
 n11-20020a0565120acb00b004a2500faf73mr3203547lfu.524.1666199999880; Wed, 19
 Oct 2022 10:19:59 -0700 (PDT)
MIME-Version: 1.0
References: <20221019083249.951566199@linuxfoundation.org>
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Wed, 19 Oct 2022 22:49:48 +0530
Message-ID: <CAHokDBnnN2FTfCdBV-S8-c3a0CHyfkH+ZNKR6eX=TEhfTh6rPg@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/862] 6.0.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regressions found

Tested-by: Fenil Jain <fkjainco@gmail.com>
