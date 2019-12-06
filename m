Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A784C11597F
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 00:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfLFXJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 18:09:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfLFXJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 18:09:35 -0500
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7861C20707;
        Fri,  6 Dec 2019 23:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575673774;
        bh=RaM+Oy3r669HifD5FxIuJATpqVr4xnCOMyVJgH185Yk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=L8h5bKKueEO0I5oS2iQ9RN3IR0mc+ygOGxRtNntofqKzJPdpSOggDh0MY/mIH2Yp5
         JbCTE0m3qVpN2FP9kReL3QST9InhiBTvNx1JIRBEyLM/tQRJ4ji3T7XD/O0L38ppS4
         766tnAJxXq0YAAB4moGKFla/6kgcZ7xIQvI0eygE=
Received: by mail-qv1-f43.google.com with SMTP id n8so526650qvg.11;
        Fri, 06 Dec 2019 15:09:34 -0800 (PST)
X-Gm-Message-State: APjAAAVJYOnvYhoTAWgz3LFJt+6gQoqRV5EPHs5eOKSYc7oIYeBmXjMA
        q78D9GW4XR1p7u7SNvj3ZgZPP/FZVaBS2O/ktQ==
X-Google-Smtp-Source: APXvYqzWnNwzf8dLCUJCUqH51dSyQLO5ASJiJcUfiAC/hyQCDGeMzbYC7t2xZ1SBUVM1WYey++254IRzBkf23iPDnNw=
X-Received: by 2002:a05:6214:11ac:: with SMTP id u12mr15257895qvv.85.1575673773643;
 Fri, 06 Dec 2019 15:09:33 -0800 (PST)
MIME-Version: 1.0
References: <20191206211821.E21A0206DB@mail.kernel.org>
In-Reply-To: <20191206211821.E21A0206DB@mail.kernel.org>
From:   Rob Herring <robh@kernel.org>
Date:   Fri, 6 Dec 2019 17:09:22 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJzm4uzGCzmUzwo32zu5EwS6O0TnpxFgGpAcOYvAi2zgg@mail.gmail.com>
Message-ID: <CAL_JsqJzm4uzGCzmUzwo32zu5EwS6O0TnpxFgGpAcOYvAi2zgg@mail.gmail.com>
Subject: Re: Patch "kbuild: Enable dtc graph_port warning by default" has been
 added to the 4.19-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 6, 2019 at 3:18 PM Sasha Levin <sashal@kernel.org> wrote:
>
> This is a note to let you know that I've just added the patch titled
>
>     kbuild: Enable dtc graph_port warning by default
>
> to the 4.19-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>      kbuild-enable-dtc-graph_port-warning-by-default.patch
> and it can be found in the queue-4.19 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
>
>
>
> commit fb5901019cef9ed5a76ddeaf83eccff8b2bd5c28
> Author: Rob Herring <robh@kernel.org>
> Date:   Fri Nov 30 09:08:21 2018 -0600
>
>     kbuild: Enable dtc graph_port warning by default
>
>     [ Upstream commit a2237fec1e0645d1e99e108f2658c26cb5a66c74 ]
>
>     All the 'graph_port' warnings have been fixed or have pending fixes, so
>     we can enable it by default now.

I doubt this statement is true when backported unless all the dtc
warning fixes are backported. I've seen some backports, but it's
doubtful anyone checked this.

Rob
