Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F41BEB4A
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 22:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbfD2UCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 16:02:23 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:40751 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729140AbfD2UCX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 16:02:23 -0400
Received: by mail-it1-f196.google.com with SMTP id k64so1030363itb.5
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 13:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=d5+AR4ZQ6S8Je85I3GXhGfH5pQCSFdPGrCwlud052ps=;
        b=XRN9VSnXHB9YOZLhHV+j78/FmX9TQONi+10x6wv8ySgEM5Q3gC4vGptmW/bxkiWCCY
         rbcj40eh19ktqbvfBBaI7hdAi4X7nV/L6e/YdSS+D+EnzRxv2YhH95gH9aH/gutPNhO4
         RJsx+Ng3drdHuugTlgCMR2KJLCwrOUInFIlaTNKgT+fEPSEflUTe81/58oCezp2WB53J
         Tdx9M6r9uvjF5dJT3y8Nur7B6mBnp1vd2obduvs8Sw5WW76/Khxa+GnxKWThbOxThEYI
         WW9SEpLLQwn3CoVL/FBE6o4G0S4hGvPjxIUy76C2Ys9mrLSEiwClLRCuBLFDnHirvptg
         mgMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=d5+AR4ZQ6S8Je85I3GXhGfH5pQCSFdPGrCwlud052ps=;
        b=LVhmvDD9b9al98qJ9JUZbC49pM/A4lA+uSap0MfCZdcCMRDcLmMfqgl9P+OmLMwqP1
         Jfm3lrW8/m6D0hU0QSb/KtOAs8VQiyOZ0/u8qTiw8hnfmGZV/4Yg4TDZhSuSYmBSl2lW
         BtqiCjr46R0EB+mI1VOS3sdvY8uiXUdqS06+OeuyDBGmyrclyuAlHOOQPw3Vzbd9WnJ1
         b/oH7yPUOUZfmbKL8rchR1nbIgfw864aGp6TTJFgQ7TXla3pnlZE/6YngcwM227IdDf1
         eaXGryHwzaMXqJEkoKoIy7fKYvgVPq0eXT3vtqXyOvtXq8hmV08ucDWUITGDQ5hkOl1a
         wmQQ==
X-Gm-Message-State: APjAAAU34/JIp9R2CuYwnNpUw5d4SynhZYMPJVYPgK831IJZq8puxJYH
        i8tigAq0bSY9lS5XygwtqkR+hQ==
X-Google-Smtp-Source: APXvYqw118+txrOO593MhkfuosJ78cNcNeAwZ0b8WAls8UIMDjjD/RyZt63kf1zMwrwLeq+0e7uoZQ==
X-Received: by 2002:a24:1f06:: with SMTP id d6mr645397itd.11.1556568142581;
        Mon, 29 Apr 2019 13:02:22 -0700 (PDT)
Received: from localhost (c-73-95-159-87.hsd1.co.comcast.net. [73.95.159.87])
        by smtp.gmail.com with ESMTPSA id v25sm7723994ioh.41.2019.04.29.13.02.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 13:02:21 -0700 (PDT)
Date:   Mon, 29 Apr 2019 13:02:21 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Anup Patel <anup@brainfault.org>
cc:     Christoph Hellwig <hch@infradead.org>,
        Palmer Dabbelt <palmer@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anup Patel <Anup.Patel@wdc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Atish Patra <atish.patra@wdc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Jiri Slaby <jslaby@suse.com>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH] tty: Don't force RISCV SBI console as preferred
 console
In-Reply-To: <CAAhSdy1nVFCwiP6vyy9i2f+S2WxLodmdwpwUKZUHYz15YfR64g@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.9999.1904291254300.7063@viisi.sifive.com>
References: <20190425133435.56065-1-anup.patel@wdc.com> <9a8be7ef-e62e-2a93-9170-e3dc70dfb25f@wdc.com> <20190426062133.GA28529@infradead.org> <CAAhSdy1nVFCwiP6vyy9i2f+S2WxLodmdwpwUKZUHYz15YfR64g@mail.gmail.com>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 26 Apr 2019, Anup Patel wrote:

> On Fri, Apr 26, 2019 at 11:51 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Thu, Apr 25, 2019 at 09:41:21PM -0700, Atish Patra wrote:
> > > Do we even need HVC_SBI console to be enabled by default? Disabling
> > > CONFIG_HVC_RISCV_SBI seems to be fine while running in QEMU.
> > >
> > > If we don't need it, I suggest we should remove the config option from
> > > defconfig in addition to this patch.
> >
> > I think the whole concept of the SBI console is a little dangerous.
> > It means that for one piece of physical hardware (usually the uart)
> > we have two entiries (the M-mode firmware and the OS) in control,
> > which tends to rarely end well.
> 
> I think the SBI console is only useful for early SOC bringup and early
> SOC debugging when most drivers are not available in upstream
> kernel. It cannot (and should not) be used in production deployments.

Usually the primary use-case for an abstract console interface is for 
desktop and server users.  Usually Linux distributions want a hardware 
platform-specific bootloader or BIOS to specify and control the console.  

Originally I suspect this was implemented in the SBI for semi-hosting 
purposes, but that's no longer really applicable.


- Paul
