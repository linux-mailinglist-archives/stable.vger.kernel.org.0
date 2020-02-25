Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C09F16BF01
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 11:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730355AbgBYKmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 05:42:51 -0500
Received: from mga07.intel.com ([134.134.136.100]:55486 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729417AbgBYKmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Feb 2020 05:42:51 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 02:42:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,483,1574150400"; 
   d="scan'208";a="436220145"
Received: from ayakove1-mobl.ccr.corp.intel.com (HELO localhost) ([10.252.12.5])
  by fmsmga005.fm.intel.com with ESMTP; 25 Feb 2020 02:42:47 -0800
Date:   Tue, 25 Feb 2020 12:42:45 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Garrett <mjg59@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] tpm: Don't make log failures fatal
Message-ID: <20200225104245.GC8136@linux.intel.com>
References: <20200102215518.148051-1-matthewgarrett@google.com>
 <20200104053108.B393D2071A@mail.kernel.org>
 <CACdnJutSTAK8JA_dD9Mo_sNaZxK5GbUxa=xx7xrysh9gPqQNtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACdnJutSTAK8JA_dD9Mo_sNaZxK5GbUxa=xx7xrysh9gPqQNtw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 20, 2020 at 12:22:44PM -0800, Matthew Garrett wrote:
> On Fri, Jan 3, 2020 at 9:31 PM Sasha Levin <sashal@kernel.org> wrote:
> >
> > The bot has tested the following trees: v5.4.7, v5.3.18, v4.19.92, v4.14.161, v4.9.207, v4.4.207.
> > v4.14.161: Failed to apply! Possible dependencies:
> …
> > v4.9.207: Failed to apply! Possible dependencies:
> …
> > v4.4.207: Failed to apply! Possible dependencies:
> …
> > How should we proceed with this patch?
> 
> Ignoring these kernels should be fine.

Please, (sanity) check:

  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

Modified the commit message:

  Cc: stable@vger.kernel.org # 4.19.x

/Jarkko
