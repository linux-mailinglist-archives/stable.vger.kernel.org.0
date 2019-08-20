Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D006F96009
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729853AbfHTN3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:29:45 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:46955 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728993AbfHTN3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 09:29:45 -0400
Received: by mail-lf1-f50.google.com with SMTP id n19so4114938lfe.13
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 06:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dVXKi/QNF7gMSFjciMcC9NUdROHEwetABxZI+JRP03M=;
        b=nI2H3FkId20+GX/q5DwbGLXo3iOOD8zVcsNXmlXoGesf2C/YUyolVfRvwdejO1XVwR
         jMgqQLW9arxHo3WB/592Ww9lKSQxU/q9fr9dIFes12rp0HQpjEzhVxm2SNDyE9Qcslb2
         6RNr3Pmh4W6hTJee4tO7LPoOIRyJzJBOYk/lm3waue6KpFTpXUPd1Tlmec+XkJU9BNRg
         D9XrG6sPJZUmADrazToban/ufK9C9L19P0CZdzMnb7FdRFERTI8HchJ7dk8UvnnKfzUE
         A3pa6zGuknLBx7Y8MxXZkzyO+Tok/5QJdv3IIbkzDsHxLPiv64BmN+bcsYU6JA9fTpvy
         FvVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dVXKi/QNF7gMSFjciMcC9NUdROHEwetABxZI+JRP03M=;
        b=WeI21iAhghZiHlXBs3InF8ieNnwbJ7vjPveWnOsyywy27gZIPqBffK0/Q4kAwSVdCQ
         MujKXMwxH/blG7S08LfxC8n3zj/gF/4UUT4b88F65vUgsUjmCYgnq960hDoMrjmDjhSJ
         BjDslPlppnRuFqdATAi0SgYMiIEMWaE+w/oa2DvUfJcdqRidwm0kBzANy4V1VX0Z8s0h
         k8panCugB4vSUYt4Cyj5l9COERfdr8FMGX7c/4SK1gGFeqrxrmuILGlk0hyEf+McMCgc
         B5bQJbZxMXNaMaxoWtwFItOZ28S3wpieN+EJx6AvgRoKBJlnDfsaxkr2EZxT3Mv7kBcU
         PMDw==
X-Gm-Message-State: APjAAAVLLhTS8OPEW3NJgIiZoiqvjeN6s2m3oe4gxJDqILACtIrB3AyX
        rdDSA/t3/IDpDak+yhlFpy/lrApca4dhHhP/ugmcgg==
X-Google-Smtp-Source: APXvYqzPNoszy8/IvopqB6mWuhT7vEXy4WTXD3Ky7CuOdRmUDT8LkJqP8liTp2XaoyUmM70YhgxSZfDl6D5O3O5aGr0=
X-Received: by 2002:ac2:4c07:: with SMTP id t7mr13951316lfq.152.1566307783313;
 Tue, 20 Aug 2019 06:29:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAK8P3a0gX2dM=VDjs2Ezh1EYM-buXCZ+79bdG2E+HCjO21StcA@mail.gmail.com>
 <a1f81a90-26e5-364b-743a-25a3525a9e99@xilinx.com>
In-Reply-To: <a1f81a90-26e5-364b-743a-25a3525a9e99@xilinx.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 20 Aug 2019 15:29:31 +0200
Message-ID: <CACRpkdY2zJNGMkf5+F1Zu2CrtG3-059uwsQopm0rS=aZUxjJzw@mail.gmail.com>
Subject: Re: stable backports, from contents found in xilinx-4.9
To:     Michal Simek <michal.simek@xilinx.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "stable-4.9" <stable@vger.kernel.org>,
        gregkh <gregkh@linuxfoundation.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 16, 2019 at 8:54 AM Michal Simek <michal.simek@xilinx.com> wrote:

> What's the purpose of this work? Make v4.9 better?

Yes. The purpose is to pick all stuff you have backported and see if it should
actually be in -stable so that stable is stable for everyone. It's kind of
crowdfunding stable development.

Yours,
Linus Walleij
