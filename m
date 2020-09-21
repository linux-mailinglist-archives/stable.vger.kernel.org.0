Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539C6272AE8
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgIUQBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgIUQBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 12:01:46 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DCCC061755
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 09:01:46 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id t14so9411343pgl.10
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 09:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=w3seJJXBjIeVg8kAaUGJhSHVmpvLqPUPgIJjzI2kkbE=;
        b=dBNxMVy5lazVO74gZngd92FywrVBf0DUS37jBjchaXSa8VQjubGfpiW3//93I30b+t
         Mogr19OEr483gjn/IZGTTK3NcG9DjjIRbtoqIWBwjUbR27tSCOox0HcDMBgRXhycHo2q
         AR4tt3Gx8pbmeXObHXY5T8E+dufkRduaPn7EFTsGi/hozNwOr6rOJarKDWgj7r3TCaer
         nZGdnUHDA0wDvsJ2srEsnNev9z7zpFF5uEtQany69rgQw4YHQilZpyQUhLql0Z5oUZqk
         /kn/Pl+rlhZyStJMaEjnl7sJddk/zWmnux2fJ6M6M+uaCDK+LFil5Maf4OXnU9sL+Q/z
         hUzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=w3seJJXBjIeVg8kAaUGJhSHVmpvLqPUPgIJjzI2kkbE=;
        b=sB34bx8gINSYiGCyZ+G3zif6MS/jsy2memnQ4Art0j7tSKONNtWN51GrEU1jCMqvVn
         J/NIYRvYUp5I1kPxLIIK944aCvNUrkyykHavh7dVDNU2QQl5JOhdpgB119ZXCl6pjABv
         zulSX9heMOgzkfkhYoIuoQNNyuRHOWUxFdcmyY54AHdBHNAp/E2g02iZFp9F/knp7wfN
         NuVCIsRDtGnE/mRMU3KIxK9IEcrr2JU/pNCQyHPk2xRrOD86FiHcePmtmcWtG9l9OPQh
         7q/wVxmbO7VGdl9Er6qUBPgsDL7WuyQ5f4e8+cyz7TkXjYTO4oiwGxTQyF4loV+UqOi0
         Wqbw==
X-Gm-Message-State: AOAM532pkudYImguiGnUiZ9dmDYnjLJQJ+5uEBSvOdUmV2TaICw+UgJm
        S1lYKGLViE1xH7sJ00dR4CWXzY9SVXV51rEhm2PXnGjQzkYtDXAp
X-Google-Smtp-Source: ABdhPJyqTWxoFWSdG8PX5FPT0uyOGDUvajtSTYhmSSCxGanxoYmNccWtJCiW+1j4B0VIZY/5COW0uRsgyyAVIMT/ugA=
X-Received: by 2002:a63:d648:: with SMTP id d8mr282343pgj.4.1600704104812;
 Mon, 21 Sep 2020 09:01:44 -0700 (PDT)
MIME-Version: 1.0
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 21 Sep 2020 19:01:26 +0300
Message-ID: <CAHp75Vc=v3wOZB7GovW6zzrQFpFB=Rpn8deo-heBLcMzTzfzFQ@mail.gmail.com>
Subject: Request for backporting 72a9c673636b
To:     Stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

Can we backport the commit 72a9c673636b ("x86/defconfig: Enable
CONFIG_USB_XHCI_HCD=y")?

Today I had experienced very well the exact problem described there in
the commit message on v4.9.236.

-- 
With Best Regards,
Andy Shevchenko
