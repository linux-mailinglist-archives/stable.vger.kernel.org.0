Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5F22E7A9A
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 16:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgL3Pqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 10:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgL3Pqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 10:46:32 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC496C061799;
        Wed, 30 Dec 2020 07:45:51 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id m5so17737748wrx.9;
        Wed, 30 Dec 2020 07:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=FoKA7gVAfReH3oyk3YoEvuOTjtVbOK3KIM2V0Ji6XEk=;
        b=RDdkntD1m3pjC6LFyHLO+tU0HHLXnhnvue52AeZYn6AhgGMiwhyx82e4sXY6kDcwzX
         TziQXa/3VhRqVkmqo8n+BIwRRX4qa6bj39675UpJ0IOdhF5noeyaHfgCP8tNrMfV3Fui
         9LeGxRzHvj92/s3CaGlFbT8MMqC7Yr7QP/wHg5f7+uWT3D6ksyn1AgVOXauvsdSaROsh
         pfupXoQs8E4FTCwWzFireKQqPriI/L5gphsioSZkKrRIx5xKM216ga5Hp/4GekWz++UB
         dv6hCIu/NG2MazrmQ/281MOirK7PR9YGkSaKitlXDP6Oo7s0NBwfgHd2ULTlh9moYaf1
         M5zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=FoKA7gVAfReH3oyk3YoEvuOTjtVbOK3KIM2V0Ji6XEk=;
        b=IhKxiv0PA9mx9CXG11Y4Nc3c0No3EyY6nJnyFBJvc2HnZLcrJA9FYCe3iUH3hGfguN
         Iu3zLxhJHl6W7FOOsGw3ABcEbWssVdR6AKe7QIPAI9N656kLMq1jsE8YL1wVPtIF83aG
         kyXIzY0+R6UgD6y51tBU++6ewgUipuxOTdmDg9630tqgjT6AVAQY8fd6qJiQY2ys6CAC
         /jZqHXEzcsIvvf74iJSafPBdTbMv6j9gEcpKHidIqyiUF33cV6GUQXAcaFi8/t7dkTzg
         5EWaYuDb6jIBjaI23KEG/S3VObw5nsT6FuU7Ddrqc9e3Xe3YWULDeLtcHDR2VUcLcKtb
         bAhA==
X-Gm-Message-State: AOAM532LiPnQqnniC42W4iu78ZJ0KIQ/GDe3rwtuaHYS+ta4W5OcuS75
        njuZs+xcTQ+/hh7hFAGLYxim32x82ec=
X-Google-Smtp-Source: ABdhPJzAzlRqQuQBd9dwMDQKlpFX82QEgmB4v5WWgC/2Eapj03Dx6oJcPfxmbMLvVAtYwk3qZqbjQA==
X-Received: by 2002:a5d:4d4f:: with SMTP id a15mr60913349wru.315.1609343150422;
        Wed, 30 Dec 2020 07:45:50 -0800 (PST)
Received: from cl-fw-1.fritz.box (p200300d86714d50000b12fbf0e2de53d.dip0.t-ipconnect.de. [2003:d8:6714:d500:b1:2fbf:e2d:e53d])
        by smtp.gmail.com with ESMTPSA id y68sm8285745wmc.0.2020.12.30.07.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 07:45:49 -0800 (PST)
Message-ID: <2f0acfa1330ca6b40bff564fd317c8029eb23453.camel@gmail.com>
Subject: Re: sound
From:   Christian Labisch <clnetbox@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Dec 2020 16:45:49 +0100
In-Reply-To: <X+yedztHPUK4Qryc@kroah.com>
References: <d1b1e6b0e3af13f3756a34131ffb84df6a209ee0.camel@gmail.com>
         <X+yedztHPUK4Qryc@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thank you Greg,

I am running Fedora 33 with kernel 5.9.16, which works correctly.
All stable 5.10 versions up to 5.10.3 are having the sound issue.
Once 5.10.4 will be available on koji I'm gonna test if it works.

Thanks again !

Regards,
Christian

On Wed, 2020-12-30 at 16:36 +0100, Greg KH wrote:
> On Wed, Dec 30, 2020 at 04:26:00PM +0100, Christian Labisch wrote:
> > Hello !
> > 
> > I could need your help ... I have tested the new kernel 5.10.3 and sound doesn't work with this
> > version.
> > Seems the new Intel audio drivers are the main reason. What can be done ? Do you have any ideas
> > ?
> > 
> > Intel Catpt driver support is new ... This deprecates the previous Haswell SoC audio driver code
> > previously providing the audio capabilities.
> > And I am having a Haswell CPU -> Audio device: Intel Corporation Xeon E3-1200 v3/4th Gen Core
> > Processor HD Audio Controller (rev 06)
> 
> Can you try 5.10.4?  I think a fix for this is in there as was reported
> by another user yesterday.
> 
> If not, can you run 'git bisect' on the kernels between the last good
> one that worked for you, and the one that doesn't?
> 
> thanks,
> 
> greg k-h

