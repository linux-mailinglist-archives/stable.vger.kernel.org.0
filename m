Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED53D3B827D
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 14:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbhF3Myf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 08:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbhF3My1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 08:54:27 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6274FC061768
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 05:51:58 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id m1so3061097edq.8
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 05:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YZVcvXsh9AfzJI6jbm0SsE03VaPhGLXjHeQSQx7brV4=;
        b=XeSerHgCDgJE0QIu3Cq3gv8sFnHdnDrcWv63/iUtqeUsffeXC+/dUkNPVr90Wuq2uT
         3y9EXjcez2a7aaCkyrNbfh0RIA1pESpwtnLM/3jNimq1Ni0ldSNvO7mipJz7OFzkay1K
         cJMNGRQnmSCQ7O3Z/G0QkhW2h4zwNa3EEYB8Hi4+nt5+VwhnEnQUgjwtGyLGyCuuHcPK
         eZFywlgGu1wZ1pfKKqX/ndFZB/qrIgXWygGl3C3zTS4+RpwsI+FFxEnXMiBbCKE1PeeA
         GdBzxjzXl9ZlzQak5KR2EL2lYgY07cwYbR0ZCbaaSnoAx9lX4mgDO+8MOoh9i2SbKt+U
         lNdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=YZVcvXsh9AfzJI6jbm0SsE03VaPhGLXjHeQSQx7brV4=;
        b=slO+bDSp0aqGtlss6e4ZmSskXjZX86GL9NMAVaxy6dmeYJN+qBlMrj1qTMJgDZ59uf
         kpYjz0jf9iVc4daeYnMOuq/AXU/1PGtemhTaZC5Js7KnRUy1s1YsOB/DH4OsR8pFFgCz
         Aktjqnv+YlMQBQ3arSVmneVT2qPN4lDQcgGG1UXfmd0Sr3DSt0/zf9w8WxC9J9D6jdSS
         aHopobVKjyGoD+XCcHCh29w9Y8PGs+fcWMwi8rBTrE9/LU3OLAJg1NVpShgwJsiWj99s
         sx5Bu9tdK85x7F4YAA5NcMrP4ML1AfTA1BfNsQkH+8hlggeiSZefmgW+GAPwnnUK5mjn
         sOag==
X-Gm-Message-State: AOAM533yqjHf0EAptcI8mKMrNhAWtimqvGin70YfOfTFgZ2N+XbqJnyG
        J6PFpPBxKL/P3mubmUZnepg=
X-Google-Smtp-Source: ABdhPJwyf46rMdiUnsEenWD7zMuqf6I5CvJWYIhKLiSPmQ9A9wBJNXaNmAXLPu+nikL9P/7S5hZsJQ==
X-Received: by 2002:a05:6402:1001:: with SMTP id c1mr46334020edu.26.1625057517040;
        Wed, 30 Jun 2021 05:51:57 -0700 (PDT)
Received: from eldamar (host-87-6-245-254.retail.telecomitalia.it. [87.6.245.254])
        by smtp.gmail.com with ESMTPSA id z10sm7884226edc.28.2021.06.30.05.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 05:51:56 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Wed, 30 Jun 2021 14:51:53 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Anil Altinay <aaltinay@google.com>, stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: CVE-2021-3444
Message-ID: <YNxo6REUcm8gFdjR@eldamar.lan>
References: <CACCxZWMREz1AVchULrWpdvtXYdDXJPNbC3qJicQ-S6UnfTbCUQ@mail.gmail.com>
 <YNuYZqgFY5VM0hRr@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNuYZqgFY5VM0hRr@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Anil,

On Tue, Jun 29, 2021 at 06:02:14PM -0400, Sasha Levin wrote:
> On Tue, Jun 29, 2021 at 01:06:00PM -0700, Anil Altinay wrote:
> > Hi,
> > 
> > I realized that this cve(
> > https://www.openwall.com/lists/oss-security/2021/03/23/2 ) is not in
> > the 4.19 tree but the commits introduced the vulnerability before
> > 4.19. Is there any reason that the fix was not cherry-picked to 4.19?
> 
> Backport wasn't trivial, and no one seemed to care enough about 4.19.
> Feel free to backport the fix and send it out for review.

FWIW, thre was/is some work in progress from this for the 4.19.y
series and in fact they are already done by Thadeu Lima de Souza
Cascardo, based on earlier version from Daniel. They are not yet in a
form probably to be accepted for stable@... they need some adaption to
commit message to reflect the needed changes for the backport, as
clean cyerry-picks were not possible and are based on earlier versions
of the patches.

There is a prerequisite needed, which is not in mainline, which is a
aprtial undo of old commit 144cd91c4c2b ("bpf: move tmp variable into
ax register in interpreter") and on top of it first a backport needed
for e88b2c6e5a4d ("bpf: Fix 32 bit src register truncation on
div/mod") (which is the fix for CVE-2021-3600), and then a backport of
the CVE-2021-3444.

Cascardo, Daniel, Alexei, should we post that series here so maybe
someone is able to fixup the patches as needed for inclusion in
4.19.y?

Regards,
Salvatore
