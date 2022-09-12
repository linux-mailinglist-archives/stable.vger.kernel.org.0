Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61DD5B5CA1
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 16:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiILOtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 10:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiILOtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 10:49:06 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E742F02B
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 07:49:05 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id d8so4097753iof.11
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 07:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=7ohfoTAE2PcgEcM9qoLFqQQTH42QGCs3+uhoR9bx0xQ=;
        b=Bm862Ka5YRkEJCLBMhGB1DkFokD31fiE9BfF/g8/zLSJ57+25EIClf8CKBiWTSEQME
         o1gud7ecB/HVTIph7ahtjtlUkmXqqnwz6rzFsoPZL1EFi0HGnwpnqbqueXxvLsYcpfel
         KYxOLmk6BigEIvjXbAj4jHQTUky4/M96RGJqrlA7GZdPIbZa+ewcF3kvRSVaewyfHEov
         h67PADUhNs0j16xLNqnunXW9cPKxAOqLU/n1o+cXhPVxIs3zRZy491SXFQ/h2FlfZN/R
         o67eI39Fjhai+5hS9JaPRoxqTKQ/IYaCbPxGKPeKajw2U7glm27FZhg+BQ2r4gILKiY3
         p2ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=7ohfoTAE2PcgEcM9qoLFqQQTH42QGCs3+uhoR9bx0xQ=;
        b=Z9DxUaQ7sQf5vlkV4AF2iY7ho+EflnFMibdh6XAwUL9rw3owk86vbrv4KhJs4FDzmL
         87evnHTFekbL42UkCZv1gDeMq5BQIhtjVLvyZz1j0yzMisepjTo/nQOtE1hTmAYI9b7K
         IP85qpbD/Je0XgSpDBrkMufAhjbkO9hQo4fxJII2XvCLwkTBOKD5/4Wxw/I6+wiBw2DG
         LghvfzbHlMJhOz5a9spoOFXbwy0oRPjaMVGkLB0lRUmiyZf4Pf/Aa+NvL5YD72XNndMc
         FSI7wjGTB4e5lTUKeNiVIOHC/2ZLXQTF6dBLbbEfzUXU1iLERi+QZH/RvtU5a90sz8eS
         O2Kw==
X-Gm-Message-State: ACgBeo0mAcBjxCpgmjpjQk/SkCHICH26/DuvG4YYckGevCQqNy4+pU5Y
        X+LqQIwaJImLuydB/p4pfv/xs9xMbhfr/I6tjVWqM8q8jCg=
X-Google-Smtp-Source: AA6agR5NOh4xHemRkZK6t5AE7Hi6hHhxHdiL0FLjO4sH4lzm6iPn7EgrdMCyJbWiOk5BmbwA+bWfb85sauxirZsEaPM=
X-Received: by 2002:a05:6638:3590:b0:35a:1f5a:37ab with SMTP id
 v16-20020a056638359000b0035a1f5a37abmr5014161jal.37.1662994145280; Mon, 12
 Sep 2022 07:49:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220912114842.762355-1-eugene.shalygin@gmail.com> <Yx9EJbyjFaLTuAzV@kroah.com>
In-Reply-To: <Yx9EJbyjFaLTuAzV@kroah.com>
From:   Eugene Shalygin <eugene.shalygin@gmail.com>
Date:   Mon, 12 Sep 2022 16:48:54 +0200
Message-ID: <CAB95QAQd--Pp8BCHPEniz_pFC9-0NR-_mZ789sVj1wPw6wP0rA@mail.gmail.com>
Subject: Re: [PATCH 0/1] hwmon: (asus-ec-sensors) autoload module via DMI data
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Sept 2022 at 16:37, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Sep 12, 2022 at 01:48:41PM +0200, Eugene Shalygin wrote:
> > Backport of the 99abb0468cc8 onto the 5.19 branch.
>
> This is not a valid commit id in Linus's tree :(

Oops, sorry for that. The correct id is 88700d1396ba, but I'm not
resending the patch, because in the meantime Sasha Levin backported
all the required commits to apply the original patch, and the patch
itself, to the stable-queue repository. I guess that superseded my
submission.

Best regards,
Eugene
