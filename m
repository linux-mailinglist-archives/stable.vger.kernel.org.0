Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9893CA01D
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 15:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238108AbhGONzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 09:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhGONzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 09:55:01 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30384C061760
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 06:52:08 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id z9so5218864qkg.5
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 06:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WOtIhKC8RiEkmTHieDAq65Q6AwB2yFROggAg00dRKkM=;
        b=tn9DXcZyImRQ8THOHjHdmchVy6sVIphjB/5uYXBlbeZ49Ar37cBAVay+11DpsytbzQ
         v7jTYspsZ4YHn4eP8QT/o7qCEnJkpVPMUhmHLVvGMfx5uKIaLv489uckXff9vFxxLs1V
         8iBNuP4oqFGocy4IXcig1JXvsrssco8xkL8u9kfLCmAnXFFGSPtyv8mKHfSBgX3NMtwP
         2uzqZX/IktknMDFVa/DoasN82+BOG1Z2z26BzfbZyQB6b0DvA0DSAyY0tOoMbKUmlAgT
         73hzvXAvKaCYVBHmgZTLM3Xvs2SM09KTR6aS2m6cQVDTPUfz9PSwGIZ0bUZ3wlvc97Z0
         uUTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WOtIhKC8RiEkmTHieDAq65Q6AwB2yFROggAg00dRKkM=;
        b=ffbYBjdPxNOzAasnDV3+WOUOt7T3aMIrwN3cf5h4NN+0cCole6EGb2TRY/+Nz7Fznj
         qTv9w4VVAJ4s2SnD1EaKrVMOf6YqKL/w8XXLZXmFlIMQyQiXRNcWLA7ous8V/50HH2dQ
         Mmzx7taJralukGzn3FRw3d6uFcqaxTN2vc3Nr0Zhs/0enOcr3eGsDm3V2FqeKPVNlYqu
         4nrAkbmFbs1ZGl0FHcSD/HlAFekZkSkhkX+vtLnvhDFKF/WcVvuD38hn+JQJ+TLQyDzM
         DaaACZaCGpa+e/50mwI1VHB1yYgiByRdwr0wrg4R2ycJk3923qtfVXBZbLbhIRiuH538
         Y+Mw==
X-Gm-Message-State: AOAM53147+8Q3mtIxvnX2+3qm8OvNnFGyjmPkhfd9XMtCzp5BlOq3/Rx
        TG2sYToJY1OITm7eg7U0qvDMkP0/HM0h8M1+8YlfXQ==
X-Google-Smtp-Source: ABdhPJxHitSu7kv7K8vYpfCwFPk+39nnv4juqPbD0x0NVPHWy4GnXiZVwu0zLQxNJWq7PBHwpToLlY8umBXyAWdzjOU=
X-Received: by 2002:a37:a5ca:: with SMTP id o193mr4090068qke.352.1626357126991;
 Thu, 15 Jul 2021 06:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210714224225.Gmo7sht2E%akpm@linux-foundation.org>
In-Reply-To: <20210714224225.Gmo7sht2E%akpm@linux-foundation.org>
From:   Alexander Potapenko <glider@google.com>
Date:   Thu, 15 Jul 2021 15:51:30 +0200
Message-ID: <CAG_fn=U1U2b4Q_rvT8MzkdaAW0cqWkEyjmeE2BiZE=vymEKe9w@mail.gmail.com>
Subject: Re: + kfence-skip-all-gfp_zonemask-allocations.patch added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Dmitriy Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 12:42 AM <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: kfence: skip all GFP_ZONEMASK allocations
> has been added to the -mm tree.  Its filename is
>      kfence-skip-all-gfp_zonemask-allocations.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/kfence-skip-all-gfp_zonemask-allocations.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/kfence-skip-all-gfp_zonemask-allocations.patch

Hi Andrew,

mmotm and mmots were last updated on 2021-06-25, did some automation break?
