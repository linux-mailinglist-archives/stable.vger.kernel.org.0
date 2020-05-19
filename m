Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA3F1D8E21
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 05:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgESDRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 23:17:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:30695 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbgESDRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 23:17:43 -0400
IronPort-SDR: G4E1zqAl3h2vOcSkHkdf7rhr9BSiCFXNHMl3WOqt0vpf1mPKHNO9URT/UWzY8gW0zpdUvcmyE5
 rmr6Pq4d+nhw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 20:17:42 -0700
IronPort-SDR: nN+30u534C5x/E+ZsUfd0cyKu0tepiTkuKjyZkLIrR2mbR35brhx0CUlf5qxAkGWvJTUFWr1B3
 ul4cIaeKgUWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,408,1583222400"; 
   d="scan'208";a="264165179"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by orsmga003.jf.intel.com with ESMTP; 18 May 2020 20:17:42 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 429FA301B7F; Mon, 18 May 2020 20:17:42 -0700 (PDT)
Date:   Mon, 18 May 2020 20:17:42 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Bob Haarman <inglorion@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Fangrui Song <maskray@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Alistair Delva <adelva@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Kyung Min Park <kyung.min.park@intel.com>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Baoquan He <bhe@redhat.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Ross Zwisler <zwisler@chromium.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] x86_64: fix jiffies ODR violation
Message-ID: <20200519031742.GB499505@tassilo.jf.intel.com>
References: <20200515180544.59824-1-inglorion@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515180544.59824-1-inglorion@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Instead, we can avoid the ODR violation by matching other arch's by
> defining jiffies only by linker script.  For -fno-semantic-interposition
> + Full LTO, there is no longer a global definition of jiffies for the
> compiler to produce a local symbol which the linker script won't ensure
> aliases to jiffies_64.

I guess it was an historical accident.

Reviewed-by: Andi Kleen <ak@linux.intel.com>
