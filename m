Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACBBDAFE71
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 16:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbfIKOOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 10:14:38 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33041 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbfIKOOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 10:14:38 -0400
Received: by mail-qk1-f193.google.com with SMTP id x134so20961890qkb.0
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 07:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7PAitQHL+9OmPJD/qYJCL+lndrVFV+sR4lmISQrAj+w=;
        b=RwkevxXmHWQbg/1zcSGNdh0GHAV7wXHU14a+K7AgO3k15tFyk4XbTgdIYmEQOWoeIT
         ZZn0LkFYyYOZoat+vM3ee0A18fZAR9eAfuCzatQG9o03EbL/aAi/2zvBSdxm4SXWNNYC
         vjyiF5VGgJnwGnIHW0SGSBPUz46XZMd3oxISBt7B0xNbM/2/CjIf+s+5X0VO7UQTZFy8
         TQuKfVeR/jgkdkfsviuWe6cTf1DSklON+N26WZE/1KlCN4O1yEGdYsLhScL9K5Za+p+k
         U21O82aM2dgpm/POCdDFrQBqpxJZgK94gBtpIxmuP2WLpcPQPd4vqeai/HrbEkii/+Ph
         3CcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7PAitQHL+9OmPJD/qYJCL+lndrVFV+sR4lmISQrAj+w=;
        b=GfQ4uQjbxiAz8pe/hlqSnMbmySB34AVeC3b+7BuzQOJR6tv72JLvc1K+BvI3IxKVes
         ohRjxcWjzNlAQBA2ihUJ8yx3pQKVkwkXBMcaClDNRkiHK2xon4Xi66i7DwGDchNCkEhx
         kIDTIsFzzO+heniaupPYRTiQdZ7mzAV8A2P0uzCMqoiS0TtQZkSGzszajtYlc9BqnUDW
         9S49HqQYCKSAa99/CdHMrplVCLd+e7lG6ZRZG2ViRNKj61HrlhpxLWmNdCiWMhsWVhbm
         RdxyJH3FQduhIrHxwhoE66v5Th+ILgKCu2gMt4cIBsqhZUFem4FqnLhRdpiWMHwTcTQk
         8hpg==
X-Gm-Message-State: APjAAAW+UWiulKXtT+KI1MFrM5e4GeSPgH9Fr5iVOoG3PkZcA5c2S47u
        nkvXXXiz/dIng7XM3FsoPNRoygu4
X-Google-Smtp-Source: APXvYqwQDEOaub6x08imAn2lpQ+N1iCCnUTsI9A/nyGNYca8qTUPr5nXJHhnRdTLgbR1NNBCt2fhIQ==
X-Received: by 2002:a37:aa96:: with SMTP id t144mr23709122qke.275.1568211277721;
        Wed, 11 Sep 2019 07:14:37 -0700 (PDT)
Received: from localhost.localdomain ([189.63.142.156])
        by smtp.gmail.com with ESMTPSA id r13sm5947585qkm.48.2019.09.11.07.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 07:14:37 -0700 (PDT)
Date:   Wed, 11 Sep 2019 11:14:31 -0300
From:   Ricardo Biehl Pasquali <pasqualirb@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: Patch "ALSA: pcm: Return 0 when size < start_threshold in
 capture" has been added to the 4.19-stable tree
Message-ID: <20190911141431.GA21115@localhost.localdomain>
References: <20190911093035.57F102089F@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911093035.57F102089F@mail.kernel.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 11, 2019 at 05:30:33AM -0400, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     ALSA: pcm: Return 0 when size < start_threshold in capture
> 
> to the 4.19-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      alsa-pcm-return-0-when-size-start_threshold-in-captu.patch
> and it can be found in the queue-4.19 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Hi Sasha.

This patch was reverted by the commit 932a81519572156a88db
("ALSA: pcm: Comment why read blocks when PCM is not
running"):

  This avoids bringing back the problem introduced by
  62ba568f7aef ("ALSA: pcm: Return 0 when size <
  start_threshold in capture") and fixed in 00a399cad1a0
  ("ALSA: pcm: Revert capture stream behavior change in
  blocking mode"), which prevented the user from starting
  capture from another thread.

Should this be queued anyway? If yes, I think it should also
be queued the fix and the commit above.

	pasquali
