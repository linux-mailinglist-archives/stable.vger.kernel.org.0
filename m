Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B035D49E027
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 12:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239926AbiA0LDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 06:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239935AbiA0LDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 06:03:10 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51884C061747
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 03:03:10 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id p5so7348360ybd.13
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 03:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E1OHZCx3Rhx2oiGyELxxvlE7v4t4IvtjC6wE5ftozco=;
        b=TSYkxeyF9q7I03XCBICWFXpdXw98xt7G5iC4E8JimlL8xwnsE2hnsnwVPQ8X2tcP4y
         T0pMQkPYyyvIW5Zrg5wN56sdZf/t+1nzjPH8vVnO0WgWztw6wh+N8uZe+67Zti0J4cOx
         XzWt1hKp7zNUPDoKWdk0BxzuD6FBTFDXYcj1I0mDMeMbps64N8lWMkBYCRCp55YPCuGJ
         8e4fXjDBKGanSV85jjApKzy8X/wbTAwDVxlS5fPfLFt2AwipSZxeoyzbyM0Q1ZkmKkOd
         02IszmDHGXoXNz0bqhvb0OBKWiDXG7WCudGxAouuuUPP14a1niJxv9RxqleV1mu+BATm
         qdsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E1OHZCx3Rhx2oiGyELxxvlE7v4t4IvtjC6wE5ftozco=;
        b=QSF2oiLkNDI1DplDe51kH8XoJ2EvVBvI9E4k/8Jhuasfd9V+NaBy91sRA9j613e6u3
         5MkUpWwmhyRRyEmV2j1MUtR3g8e+vzogXunY+H/hCoQCJvxNIkpcMS96TBNe80XaCTfa
         JOGP/C8XxF53+VMA+N1S7eX1lXZ3K9L1Tb/raOr0VSyg2BVeLswbNAyDnpdkW2xuvIvt
         q6Od/42yxJ/hWOtJisisdtXhY6lOWd+pb+cxcClxr4lzkNb01YAIRAvqHpVRhZSfOUp/
         jxPnCAQ28EnEbRJSy/7fDweM5E3MpNA/y5yjDrCCjKvXPd+SmnYa6oWrtnFILrzEqCVq
         CMew==
X-Gm-Message-State: AOAM533pQSaWRgsKqujmThv8MgfEG7oIf1KXlwIbM4Dr+r60N52Hy2KU
        ddHIrAynvcKsrZenNONm0oXC+5sMUKtyCqkipL9eoaTPbeAkzg==
X-Google-Smtp-Source: ABdhPJxdz/jhiQ15H91Ot35YzA1DFSyUQO2xE3gRwUltWkvVDDelPxaNCFlALIo3QG0WslXSvdKjBaW2aTHIdyzNFaQ=
X-Received: by 2002:a5b:47:: with SMTP id e7mr4778699ybp.553.1643281389318;
 Thu, 27 Jan 2022 03:03:09 -0800 (PST)
MIME-Version: 1.0
References: <20220125155447.179130255@linuxfoundation.org> <ddd3f2e1-ed1d-82ce-cc8e-562be2ae5152@linaro.org>
 <YfI4oDEY7W4lxWZP@kroah.com>
In-Reply-To: <YfI4oDEY7W4lxWZP@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 27 Jan 2022 16:32:58 +0530
Message-ID: <CA+G9fYsPFjmgmAQmLT84Nmx34J-ROQDjkN0qTdYhUi-BkcnDiA@mail.gmail.com>
Subject: Re: [PATCH 5.16 0000/1033] 5.16.3-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        lkft-triage@lists.linaro.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

> No Tested-by: line?

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


--
Linaro LKFT
https://lkft.linaro.org
