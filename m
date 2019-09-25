Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 537B3BE08A
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 16:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732635AbfIYOuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 10:50:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:55096 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfIYOuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Sep 2019 10:50:19 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 07:50:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,548,1559545200"; 
   d="scan'208";a="191360959"
Received: from kmakows-mobl.ger.corp.intel.com (HELO localhost) ([10.249.39.225])
  by orsmga003.jf.intel.com with ESMTP; 25 Sep 2019 07:50:12 -0700
Date:   Wed, 25 Sep 2019 17:50:11 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-integrity <linux-integrity@vger.kernel.org>,
        Peter Jones <pjones@redhat.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Lyude Paul <lyude@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Bartosz Szczepanek <bsz@semihalf.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] efi+tpm: Don't access event->count when it isn't
 mapped.
Message-ID: <20190925145011.GC23867@linux.intel.com>
References: <20190925101622.31457-1-jarkko.sakkinen@linux.intel.com>
 <CAKv+Gu9xLXWj8e70rs6Oy3aT_+qvemMJqtOETQG+7z==Nf_RcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9xLXWj8e70rs6Oy3aT_+qvemMJqtOETQG+7z==Nf_RcQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 25, 2019 at 12:25:05PM +0200, Ard Biesheuvel wrote:
> On Wed, 25 Sep 2019 at 12:16, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > From: Peter Jones <pjones@redhat.com>
> >
> > Some machines generate a lot of event log entries.  When we're
> > iterating over them, the code removes the old mapping and adds a
> > new one, so once we cross the page boundary we're unmapping the page
> > with the count on it.  Hilarity ensues.
> >
> > This patch keeps the info from the header in local variables so we don't
> > need to access that page again or keep track of if it's mapped.
> >
> > Fixes: 44038bc514a2 ("tpm: Abstract crypto agile event size calculations")
> > Cc: linux-efi@vger.kernel.org
> > Cc: linux-integrity@vger.kernel.org
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Peter Jones <pjones@redhat.com>
> > Tested-by: Lyude Paul <lyude@redhat.com>
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Acked-by: Matthew Garrett <mjg59@google.com>
> > Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Thanks Jarkko.
> 
> Shall I take these through the EFI tree?

Would be great, if you could because I already sent one PR with fixes for
v5.4-rc1 yesterday.

/Jarkko
