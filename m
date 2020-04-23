Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CD81B5207
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 03:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgDWBli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 21:41:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:59945 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgDWBli (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 21:41:38 -0400
IronPort-SDR: sQ9WEnTgJFmZ4m2fFR7xOKLQ13E9KDDiscG0eAMZvq73Yr+Rvr18iyLRbcOEfDQIlkkZxvYw3K
 oFvZqVNH3yUg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 18:41:37 -0700
IronPort-SDR: CD2YxbVKG2TZwAYql6zhg9T7ino1fY1Mi5HuKZB8EH+PrVBtjVFDYNpQVW0QQZLAhDq21NCJ8o
 YIB60eV6aoAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="365856621"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by fmsmga001.fm.intel.com with ESMTP; 22 Apr 2020 18:41:37 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 53EBF3019B5; Wed, 22 Apr 2020 18:41:37 -0700 (PDT)
Date:   Wed, 22 Apr 2020 18:41:37 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     John Haxby <john.haxby@oracle.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] x86/fpu: Allow clearcpuid= to clear several bits
Message-ID: <20200423014137.GM608746@tassilo.jf.intel.com>
References: <cover.1587555769.git.john.haxby@oracle.com>
 <03a3a4d135b17115db9ad91413e21af73e244500.1587555769.git.john.haxby@oracle.com>
 <20200422143554.GI608746@tassilo.jf.intel.com>
 <96EA2DF4-7490-4FF0-BB3E-EC9157517918@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96EA2DF4-7490-4FF0-BB3E-EC9157517918@oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> 
> I did wonder about that.   However, cmdline_find_option() is specifically documented as 
> 
>  * Find a non-boolean option (i.e. option=argument). In accordance with
>  * standard Linux practice, if this option is repeated, this returns the
>  * last instance on the command line.

Okay so would need a special version that uses the first and an option
to pass the cmdline string.

> 
> And since that appeared in 2017 I decided to stick with the new-fangled interface :)   This is a little-used feature; I'm not sure it's worth the effort of parsing the command line for the old style.  What do you think?

I'm not sure it's that little used.  We use it quite a bit for testing
and workarounds, and it might be that some of those are deployed.

-Andi
