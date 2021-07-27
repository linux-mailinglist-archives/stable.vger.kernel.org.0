Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447E13D7DBC
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 20:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhG0Sdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 14:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhG0Sdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 14:33:41 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8294DC061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 11:33:41 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id a26so23242505lfr.11
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 11:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zkBmoT5BGY7pqcLf5WQvcbItXUocAW19PpD58jwr6I4=;
        b=ZJoV6SH43BWuxocUbln5nwnAiIaLSW9gEqoVpgBpxnjpnEKD5D3f3Oe0przokZikPf
         1CJWecwlQcK62g/aCy0cfJCfQyRlP3ueCHQYEVHMC89cMQXn0wiZCpCoC9a19f3zJ9EE
         70ETHRjMId3+h0hq14mB5IoQr/SuDb/wx5HPMutx34I8XieByBsNqZ8SHZ+wi4LqF39f
         Zx7vfWlR/WT/NDiWMxXn/q1EjxbBCAlwiHbDXveTpr7WDGI4txy7j1ue+GL5/y9vej94
         a+jRDdN6fwGzvXQ7ceN3/vSPNU6s7SkI76QUOOOxHl3+gLgJ6nkf4T2WTmWgy7AHsraz
         sQfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zkBmoT5BGY7pqcLf5WQvcbItXUocAW19PpD58jwr6I4=;
        b=X47DN6qvDkmTvH/3MdMuxYyw0Zci6zk1XDvhltgfnNMP82qLS1NdS+STPFAvCxAfVC
         IWLPNbgIikueUzoqEcyQOCmdJXLQzWAb1FQYzOV6UzKQfp6+VXPwLe7WX+/qgqspq5Ba
         w+b/Ww0bEI7QhM4FGMiWwSWVdvc48Xe4BdsUJHRnz+bkieRQSvw/y99iTTqlzqSr5pTF
         Z94SgepUZy2TM9Xt/P12A6aRlus+DEwF38AWtlEuutbZiOO4wKO1eSieSPoF8qnUPLVK
         a+zJhcjXgDKTs+HtOKOJHBxKYw71ymig33FpKaYKeAHY6IrzVtQF87DqyfHuSRLLPp1A
         WuUw==
X-Gm-Message-State: AOAM530J+VX3rbbXapcOB6LuF+/6ZTjeaqus06XxVA2vmfHchYiuem9C
        OGzcjzEFUABM1awaHOB58NM=
X-Google-Smtp-Source: ABdhPJxq+jPcszYW/u9wQX+uepWkR3UgEu37nc27RslmHHf+jg7d5j8DSLbabhHRA88ziTweum9dTw==
X-Received: by 2002:a19:5e4c:: with SMTP id z12mr15472623lfi.275.1627410819958;
        Tue, 27 Jul 2021 11:33:39 -0700 (PDT)
Received: from reki (broadband-95-84-198-152.ip.moscow.rt.ru. [95.84.198.152])
        by smtp.gmail.com with ESMTPSA id y25sm357612lfe.276.2021.07.27.11.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 11:33:39 -0700 (PDT)
Date:   Tue, 27 Jul 2021 21:33:38 +0300
From:   Maxim Devaev <mdevaev@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     balbi@kernel.org, stable@vger.kernel.org
Subject: Re: patch "usb: gadget: f_hid: added GET_IDLE and SET_IDLE
 handlers" added to usb-linus
Message-ID: <20210727213338.66f72d6b@reki>
In-Reply-To: <YQBQCmdeCGQoAUfe@kroah.com>
References: <1627394158704@kroah.com>
        <20210727210754.20af2cda@reki>
        <YQBQCmdeCGQoAUfe@kroah.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Greg KH <gregkh@linuxfoundation.org> wrote:
> Also, that was no way to show a "v2" of a patch, no wonder I was
> confused, please in the future, do it in the documented way so our tools
> properly pick it up.

Sorry, that patch was my first time, I got a little confused in the process.

Thank you for explaining. I sent the v2 for this.
