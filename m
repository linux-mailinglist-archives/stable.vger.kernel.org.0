Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203031E5F93
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 14:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389525AbgE1MCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 08:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389044AbgE1MCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 08:02:47 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52E7C05BD1E;
        Thu, 28 May 2020 05:02:46 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id c11so30885044ljn.2;
        Thu, 28 May 2020 05:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tZAAtlUG9AhJ/Atr4cE+FEtEOyGU5vjMq1zxXLMbm/M=;
        b=ZorZ4K4yDcy4gsjhpUw7Oun7inOYaU2WCjP9bqsic1m6WYUd5QevLW3/AXbdkm9PSu
         AtB17UQLllBYLMI2by7yQ/c81HwSUzqR3UaR4eLOGejdMjdkEGu2DOZqq/PjvMNhV/WO
         IgLAw0dNHgMGV1Gl1G2XsYG/ZqXTLaNLsalsaENaqueEf5htqY3JpIvAvzu21614JVsG
         nxQ1j1MNmF3fl4n/1s5aXXsUOXwwfoq44wwDJMHhTqc6NlDEE3cY6dsyisuxJIpAWFp3
         51r6WCC3chucPPhGUpM1BKRABx4bbGSCVPdYfplXOSQul4vdHxTnFqChe0DT59uJiTC7
         8HVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tZAAtlUG9AhJ/Atr4cE+FEtEOyGU5vjMq1zxXLMbm/M=;
        b=DfTLA3K1ote8Qt0/DEiiCGHmnhDUqdc7waqJsN4q1lZDs7UJYl0H71nxEgSSouohv9
         fgROrl596WMRH7+YD2f072HSs+GRhJVeEC9iZZf4SEKK9n6TFsuBqk9HjqE7v8rTw6nc
         4Uc3jM8N0gOYxuFQks2RtO5wxJPpF9wILFra+NdX/T1hC54YD38JJnF0kgzm8hzcqz5y
         fZImjkvFniuPs2sBuhzpSKzHD7YzbPxhVlJGiKoi5yxbX9s1nO2o5RwWQGMRtpotiHVk
         BUu4pDqVpYOCJJ4jNWIDZltQd2rgv02zWeBDnU5jgHL4xPVne3CbJyZ9OHBZO4nOWM/Y
         OryA==
X-Gm-Message-State: AOAM530LP4kbJ+cIE5te5hwKyRGi1RPnZKceoiaA4Vf5v/S1jZhpKHb/
        bwKgYpAnf6FLyHi24Avfg13uwggbCnw4DCNNnX63LA==
X-Google-Smtp-Source: ABdhPJwmCZRWpoHjgLbsA2QTPKomwsN+ITixXa7o67e3iIg1zmy/OAFe7ddh+2EQj5ThIgflVLMLH3fIhHSR6K+mtUg=
X-Received: by 2002:a2e:9891:: with SMTP id b17mr1395244ljj.319.1590667363018;
 Thu, 28 May 2020 05:02:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200527165718.129307-1-briannorris@chromium.org>
In-Reply-To: <20200527165718.129307-1-briannorris@chromium.org>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Thu, 28 May 2020 22:02:31 +1000
Message-ID: <CAGRGNgX5n=0OEi7hMrmgVZGD=orGpgvkyLrhmXVKSFYdBJ+eUw@mail.gmail.com>
Subject: Re: [PATCH] Revert "ath: add support for special 0x0 regulatory domain"
To:     Brian Norris <briannorris@chromium.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Wen Gong <wgong@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Brian,

On Thu, May 28, 2020 at 5:18 AM Brian Norris <briannorris@chromium.org> wrote:
>
> This reverts commit 2dc016599cfa9672a147528ca26d70c3654a5423.
>
> Users are reporting regressions in regulatory domain detection and
> channel availability.
>
> The problem this was trying to resolve was fixed in firmware anyway:

Should we tell the user their firmware needs to be upgraded if it
reports this regulatory domain instead of completely dropping support
for it?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
