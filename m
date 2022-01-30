Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCD64A34B6
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 07:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345046AbiA3Gng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 01:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241248AbiA3Gnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 01:43:35 -0500
Received: from mail-vs1-xe62.google.com (mail-vs1-xe62.google.com [IPv6:2607:f8b0:4864:20::e62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3864C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 22:43:34 -0800 (PST)
Received: by mail-vs1-xe62.google.com with SMTP id r20so8036574vsn.0
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 22:43:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:date:from:to:cc:subject
         :message-id:references:content-disposition:in-reply-to:user-agent;
        bh=Xq+nD/A82UMQfoJJ0ZSfgLN5CX/IcLxoIv64JUuUc0U=;
        b=oFKmvmHdePiovzMhOVQRbiQjsHE1rxdct8LDq3YZqgFt3iGEbGyCp1M+Ykaud0YfyC
         Js6gcuJg0jRzGANyyTw98BneaZmGOd4buWw6tjk8VSYdf1I2ueWCHCcXTu+otop44/VI
         K1D7qXem1X40j5n67EzyoKwP5NW+9oRAQAVrPfD8VHrIYoWHZABJkWBaE7kIO2tg0UcZ
         hx0N+h3ocGkjuDtP+XF2JdccEIiv/gU9blvHg/HbpevWe25Z/dFGYEu22ZFSz76Zmueh
         +pMEIVDXvQVIkY4HDrWbe/NabEQi1ryP1cYoDvXGJtMOiRws86loaNbxxSKltvLZh02j
         CvpA==
X-Gm-Message-State: AOAM533ifb/NNZ/MSKuD8mSFBKio5xvXDH3x162r75MDyt4Ck2Q5r+FU
        pLB0cWvxWFRwG7V9hjwkfHC11JlMN7w3Sbk6+zM04p0y0hDU
X-Google-Smtp-Source: ABdhPJyrEgnHeV/SDafzQ4agPysfrTnkIWSDNe4wh38WwbdnVhnjN4FiYGw6RGEAXEHgAPwEGn5T96J0ASev
X-Received: by 2002:a05:6102:32c3:: with SMTP id o3mr6002032vss.4.1643525013869;
        Sat, 29 Jan 2022 22:43:33 -0800 (PST)
Received: from smtp.aristanetworks.com (mx.aristanetworks.com. [162.210.129.12])
        by smtp-relay.gmail.com with ESMTPS id 17sm3770886vkf.0.2022.01.29.22.43.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jan 2022 22:43:33 -0800 (PST)
X-Relaying-Domain: arista.com
Received: from visor (unknown [10.95.68.127])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id E470F40187C;
        Sat, 29 Jan 2022 22:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1643525012;
        bh=Xq+nD/A82UMQfoJJ0ZSfgLN5CX/IcLxoIv64JUuUc0U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HNcW0bFPfaOm5z74eKepnng885aGpGOlKCsQTJlVVesJmOs5Slao9QAAN7KSUdMYH
         2A7BZmpgg8nPSHMqE4nzFCFYo7hVrJ5pG6ShHdrl/n27Q+cea81z1FCGzGNbMEk3qg
         1VtIHDUSgXUtkvqI+Oil7+8vQXxkwopS/RrPN1kQmgM8+T5hKqCE+iq+yY3vDuX+f3
         XehuQlOlJRvaldB/uXkzhnUxVqrLfXVZKIZHDiQ3ySbYtyJUmbxdbJneltePls5XkJ
         CZnCvTD41zNXgyu6GT+O+SIGZrasxX59OkG0vEING0pV2sruoZbEBfhxl6l3ZDw0Nv
         lISdTkirYfyCg==
Date:   Sat, 29 Jan 2022 22:43:14 -0800
From:   Ivan Delalande <colona@arista.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, Jan Kara <jack@suse.cz>,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] fsnotify: invalidate dcache before
 IN_DELETE event" failed to apply to 5.10-stable tree
Message-ID: <YfYzgrivQsC87Ukq@visor>
References: <1643461069190172@kroah.com>
 <CAOQ4uxgEkA8dvurhoyZC_qV-=ZXBYsOJfvh0+Ss44ty+qn+01Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgEkA8dvurhoyZC_qV-=ZXBYsOJfvh0+Ss44ty+qn+01Q@mail.gmail.com>
User-Agent: Mutt/2.1.5 (31b18ae9) (2021-12-30)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 29, 2022 at 10:04:18PM +0200, Amir Goldstein wrote:
> On Sat, Jan 29, 2022 at 2:57 PM <gregkh@linuxfoundation.org> wrote:
>> The patch below does not apply to the 5.10-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
> 
> 5.10 backport patch attached.

Just to confirm once more, I tested this patch along with the 5.10
backport of "fsnotify: fix fsnotify hooks in pseudo filesystems" on our
kernel, and we don't see the problem that we originally reported with
our application anymore.

Thanks again for your help on this Amir,

-- 
Ivan Delalande
Arista Networks
