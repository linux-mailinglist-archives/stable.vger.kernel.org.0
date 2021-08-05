Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111BF3E16D0
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 16:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240231AbhHEOUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 10:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240209AbhHEOUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 10:20:42 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008DFC0613D5
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 07:20:27 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id cl16-20020a17090af690b02901782c35c4ccso6065827pjb.5
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 07:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mH0dvQ3On4KZ+FTL8x24ewqE7aJRVXmn2tbwwOUGYrg=;
        b=AqMx0L6VbehDegO5gqMb+ZdlKGLg/Ik6WitDa37oWQYVoJ5aRhLfJhFYf+VCFxCgU0
         Q1Kw3VDqkrNME0kQXRCkmLQZ4JGkpLmNaSjqSFaQZhCHRwC9eC4vU68ojNMb5dQlga0s
         tO7CYcgzUydkzmjZCgTKZf9FKhse89ptROmTQXZyGx3N6b57vPgIXK8Fy5K1ScR9iah1
         Ph6jtowDIZV9exv76LYkYwL18MvQei3X84qZJeugsXz/m6pc0XknrbUqzgmzWY53fN4P
         wwebXBac535eBj1i5VwiyfMl5mM1Tn+GIuDvrFVZeq76Wl5pXjjKKwrx1NFM7ricdKCG
         niHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mH0dvQ3On4KZ+FTL8x24ewqE7aJRVXmn2tbwwOUGYrg=;
        b=CLMRlVZQu5M3obB/zP+z9pJsQqR6IXdGOXDknozn4u9lBLOgowYGFBseosroJjAHLQ
         njE4N7Xh1kIH1sMgas683fVajw2Gf/5LYHDxxr2jjQhym18NkinUvnSe4bgh2rA2qneT
         w5raZEEiSvIGezZmWABgCKGKOyNLY9LQgfZfC/+s5E3mHv5xxoLu0cAIAT3VVltNgHwY
         plMLsCot7a+ako5GxojN2TvzgYA5ofR2FXtNk4qRRLTSu1rAROAySbtpU5zhi4Bu84oR
         z9iL449T+okuFhbHshLhfeHxEFXiOvsdb0X4klo0GFgXB8s3AW5pjy06cY98hf7Fc7lk
         xI0g==
X-Gm-Message-State: AOAM531KEqaFI6F+381eei3yifpOGCocs1mWm7+FW5Gs/B3qluP89VJM
        SsFoyykYlFZHL7VYwc7ZlTsEa9fR6bTOB3fP+CPo8w==
X-Google-Smtp-Source: ABdhPJwYlzK/Zrsgvxa/RHs4jFUDdzGMjhzrXw8W/OCJpvXo7GB3dUw4D5xF/6eY//U1vTIT/D1OoqGlkMu226hky0w=
X-Received: by 2002:a63:dc58:: with SMTP id f24mr735364pgj.303.1628173227396;
 Thu, 05 Aug 2021 07:20:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210805140231.268273-1-thomas.perrot@bootlin.com>
In-Reply-To: <20210805140231.268273-1-thomas.perrot@bootlin.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 5 Aug 2021 16:30:08 +0200
Message-ID: <CAMZdPi_eBDvhvc6vcb6vAE3oV7TPDXo71-y9yMsQmyqhMLQ+nw@mail.gmail.com>
Subject: Re: [PATCH] bus: mhi: pci_generic: increase timeout value for
 operations to 24000ms
To:     Thomas Perrot <thomas.perrot@bootlin.com>
Cc:     linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Hemant Kumar <hemantk@codeaurora.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 5 Aug 2021 at 16:04, Thomas Perrot <thomas.perrot@bootlin.com> wrote:
>
> Otherwise, the waiting time was too short to use a Sierra Wireless EM919X
> connected to an i.MX6 through the PCIe bus.
>
> Signed-off-by: Thomas Perrot <thomas.perrot@bootlin.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
