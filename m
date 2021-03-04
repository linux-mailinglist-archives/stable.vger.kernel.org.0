Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C557832CEA0
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 09:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbhCDIj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 03:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236360AbhCDIjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 03:39:41 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1AFC061756
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 00:39:01 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id b7so20147788edz.8
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 00:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O3btJ+5PqrChkkGugZw2E2DdQwlVkZXPICPziV+CKdI=;
        b=XWh4Yp/VWbjRfe0LYbtR+alIXda0UFsBQZ3/n6ipfPtO8b5Ituob8zB/uVhvZxww/X
         GxcVgndbrtLQdaJkrpQrHE9OUd7CWywPC2kL3TbdkaXzdNZMw2INnBW0JEczR/EveHyR
         waFQqcI8nULq7ShLk2gqHbEJbyYVVDvuzXgPRpavDNU4IIqhmhfykL46Ipa/p6MA2VTI
         23N7NCQkpgPObiyK5H3oXyd68FKcPl8k9CEO2whilD8Ki1ZAZnL0DBFEdVvXMkZSASu1
         SsquWEzAm8MW8a1stFaS3t9ygE+wUpsfCKI8t5fFKm2AfM9G/2UgGMYvtiiTyC4QT02d
         2JFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O3btJ+5PqrChkkGugZw2E2DdQwlVkZXPICPziV+CKdI=;
        b=aR32hnCzIw+0ODioBiwNkj1E2AOQvus/zwZ5rxg11BugvWrBhUqFApSQ63NYUsY0eK
         vkjJxD1zT8tnpEFQzOflJJCZJMv0G0bNom/PfolvrTPhdoBTmwkiGe0LDsQS0PfqWtn8
         7zCidqfcdbGE4G+Dobz2CXuMyZ22cO33CPucE3igbxrBeAf+lU2RpcHGc0BTMxgFn7rr
         A2mj8CiQZunwgLV6sW10HsjckL4EOlsh4panHONYVTfUQBM41b8Q7tVcwne0WkcA39TO
         HOTTBpI3GOmuQyYD1W5hBSkL+VKWQXjMYh8b5QzC5J44MHaEpU4D/9ARDJCLHXZ/EhcD
         2Zkg==
X-Gm-Message-State: AOAM532KlhaGbow6l7TonjxMPdWRmyZVUAsb5qyRdY34O6E1IClFovkl
        S90VKAn+W9mOgYgtT8b+9Z7xFGgvUVRQ/QIbUrGuCw==
X-Google-Smtp-Source: ABdhPJx5NB+jruq00ZnDK8hLjjyPCE9HsuNKZeaOhYt37B0A8De4sToZyk2nef5GV6WzNUJOFrKfX38y64fa/f/Hb08=
X-Received: by 2002:a05:6402:5188:: with SMTP id q8mr3084679edd.89.1614847139664;
 Thu, 04 Mar 2021 00:38:59 -0800 (PST)
MIME-Version: 1.0
References: <20210208150426.62755-1-jinpu.wang@cloud.ionos.com> <YDdohfWKqvNI7AVV@kroah.com>
In-Reply-To: <YDdohfWKqvNI7AVV@kroah.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 4 Mar 2021 09:38:48 +0100
Message-ID: <CAMGffE=jXg77P--dvRZVWfj+0K4OpphUA_dz5DEY99Boi7FWMQ@mail.gmail.com>
Subject: Re: [stable-4.19 Resend 0/7] block layer bugfix
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 10:06 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Feb 08, 2021 at 04:04:19PM +0100, Jack Wang wrote:
> > Hi Greg, hi Sasha,
> >
> > Please consider to include following fixes in to stable tree.
> > The 6 patches from Ming was fixing a deadlock, they are included around kernel
> > 5.3/4. Would be good to included in 4.19, we hit it during testing, with the fix
> > we no longer hit the deadlock.
> >
> > The last one is simple NULL pointer deref fix.
>
> All now queued up, thanks.
>
> greg k-h
Great, thanks!
