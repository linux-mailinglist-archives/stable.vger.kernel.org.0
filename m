Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 605FBAFE94
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 16:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfIKOUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 10:20:18 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:42761 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfIKOUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 10:20:17 -0400
Received: by mail-qk1-f175.google.com with SMTP id f13so20937156qkm.9
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 07:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xHRPEB+HwPgUl7AdHiN+kxNboVqbgioTe9SVuCIn0KU=;
        b=a8sNmPgaASgydnqo3Lh7B7L8QtrViGEdupvZ+LJNu28pl2VZbBSwrb2j/6CvcJu54N
         OioFdUX4zgHGVONxMvae/cVdDm2B7ZY+GGEihEle7+zHGr9RY5fkyQnEboqukj+kfO+W
         lnvtnB5SVGEM+1FrmXtgRzi/2r1CLRUgeTOnbzeAjJNaF4l6V8PLQ9v+ThlYOcG/zc46
         2ScnC2zp/rR+4d0oT+vg49b5j4ZBuAbfFqxuxlZKzUE3OiPIM+2hTqZFilgFVcSg5Ewh
         WtrwQ0tLxo/nyk95aJg+oDCOxKkDBsZy5xOfzXGZ91JqMtCmNZWRKaKay3+JBVb4SNKe
         y2yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xHRPEB+HwPgUl7AdHiN+kxNboVqbgioTe9SVuCIn0KU=;
        b=RiGaMg/lsmJfnT69PykfRGebifd+hv6q1X9frrh/NZBN1Yd45+cVYCpMOxFR1SmnSs
         cxS0GzgDFaI9vyq11KHXcB3I4jIcl4wRZug8VlxAscEMsOBF9yls45wlv1Po/Hh/d9I/
         TBpcxiaiy/hlaJZktJhimhaVjlQLHyeicD4xdcp7V3eFyAa8sjrpwWHhDMP+E7zZopsK
         9O/x4m/Yu8+//LSkiPP4MlD4LAeiXgcLQVbdUgRF6/MIn8sP4iqfB9bZ6inB2SvxYKLy
         TxYU8jl/KIZFatIZG9uVol00CHPXrLOvVvuKCOMFfBPZjZSqhK9lbhirus0prOSUnd/9
         BDhg==
X-Gm-Message-State: APjAAAXICoYN8qYrRVRetKM0TtRCa99y2GI9+xc4n+7F2iCNj/SxwKWL
        O7UQcVS0jKMiRAMLV5jM4mU=
X-Google-Smtp-Source: APXvYqy48GOWpoz4JdmuA+ZAeQHVHmSlPApgXliKnZqjC9RVYavmiCAptOQU/keAzoqjHQKXKktYYg==
X-Received: by 2002:ae9:ee09:: with SMTP id i9mr4679150qkg.438.1568211615773;
        Wed, 11 Sep 2019 07:20:15 -0700 (PDT)
Received: from localhost.localdomain ([189.63.142.156])
        by smtp.gmail.com with ESMTPSA id 44sm13343088qtu.45.2019.09.11.07.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 07:20:15 -0700 (PDT)
Date:   Wed, 11 Sep 2019 11:20:11 -0300
From:   Ricardo Biehl Pasquali <pasqualirb@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: Patch "ALSA: pcm: Return 0 when size < start_threshold in
 capture" has been added to the 4.19-stable tree
Message-ID: <20190911142011.GB21115@localhost.localdomain>
References: <20190911093035.57F102089F@mail.kernel.org>
 <20190911141431.GA21115@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911141431.GA21115@localhost.localdomain>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 11, 2019 at 11:14:31AM -0300, Ricardo Biehl Pasquali wrote:
> This patch was reverted by the commit 932a81519572156a88db
> ("ALSA: pcm: Comment why read blocks when PCM is not
> running"):

Sorry. It was reverted by 00a399cad1a0 ("ALSA: pcm: Revert
capture stream behavior change in blocking mode"). The
commit I mentioned just add a comment as described below:

> 
>   This avoids bringing back the problem introduced by
>   62ba568f7aef ("ALSA: pcm: Return 0 when size <
>   start_threshold in capture") and fixed in 00a399cad1a0
>   ("ALSA: pcm: Revert capture stream behavior change in
>   blocking mode"), which prevented the user from starting
>   capture from another thread.
