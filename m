Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC78D182043
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 19:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbgCKSBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 14:01:11 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43387 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730468AbgCKSBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 14:01:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id c144so1753931pfb.10;
        Wed, 11 Mar 2020 11:01:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4rbFCslqjgH4sXZwXRxajxY2P/fkCA2L0OS7xWGtM24=;
        b=gEBaAL1S79UPP4QUiKP2Fi8zuRAbPMoOO44U4NArFUQrk9iyjBNphW8J+WOGy5UUz2
         /zyMIuEPLwLXK82aBe7LVi3564xY/MrR0CKArKWmwlh+ipou1AMILeOYU2Y5GDsnNWh9
         K5emTXokFSQ+FzIgp9e3N68iiVX50fbpviPtVQ2BkIdeJ2970TbHl/8G3vyte6NE3LYa
         i1D4U0o6jNZOVI5KKQ4cB3FQ7xgwVIzxkq6Kqey8Rw3ioabICTXSFL/+tnE5LIS9AGHc
         M7aniFuRKCtDCAvowATGCK8nZgyPXN/90Zko5w71s7x/DL/Bea4eUB/zyhdWGBwQoI/M
         AV3Q==
X-Gm-Message-State: ANhLgQ07O9LW/6KbhYJo4Qbrsdnlad5yDUUfqs2MLg1v4jmq0nIoQ2a1
        GqzSqenoDf4W9S+7xuwlesAuw5ArxUw=
X-Google-Smtp-Source: ADFU+vv3iN5bf6Nx81FXMawuf3VzC8L33BaYvuVyxtyYoRAzzmsqgFyyXWtfhSheMAx7NV680qGZ1Q==
X-Received: by 2002:a63:6202:: with SMTP id w2mr3994411pgb.154.1583949669546;
        Wed, 11 Mar 2020 11:01:09 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id w190sm1323524pfc.219.2020.03.11.11.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 11:01:08 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id D91F14028E; Wed, 11 Mar 2020 18:01:07 +0000 (UTC)
Date:   Wed, 11 Mar 2020 18:01:07 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH] kmod: make request_module() return an error when
 autoloading is disabled
Message-ID: <20200311180107.GO11244@42.do-not-panic.com>
References: <20200310223731.126894-1-ebiggers@kernel.org>
 <202003111026.2BBE41C@keescook>
 <20200311174134.GB20006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311174134.GB20006@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 10:41:34AM -0700, Eric Biggers wrote:
> On Wed, Mar 11, 2020 at 10:28:07AM -0700, Kees Cook wrote:
> > On Tue, Mar 10, 2020 at 03:37:31PM -0700, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > It's long been possible to disable kernel module autoloading completely
> > > by setting /proc/sys/kernel/modprobe to the empty string.  This can be
> > 
> > Hunh. I've never seen that before. :) I've always used;
> > 
> > echo 1 > /proc/sys/kernel/modules_disabled
> > 
> > Regardless,
> > 
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > 
> 
> modules_disabled is different because it disables *all* module loading, not just
> autoloading.

Clarifying this on your patch would be useful, otherwise its lost
tribal knowledge.

 LUis
