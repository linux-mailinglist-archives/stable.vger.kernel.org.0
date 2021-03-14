Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30EB33A369
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 08:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbhCNHWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Mar 2021 03:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234261AbhCNHVr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Mar 2021 03:21:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C08E64EB6;
        Sun, 14 Mar 2021 07:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615706506;
        bh=+035NT6833lMOo3kafVtybz/eGl3Vllty6ONqGvsQkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WOXGE6ItIE6a8Gb75l5tPM6KwZQz7z/FnDCbysNlyEkGz1k3FIeQeciwmVeQtT1yr
         oAAXJ68niJhXIXPq1HR0NS2wv7DgVihaffFu17ByMcbqibOHYbKV0E1E4Y9hisDyZh
         iUIw5M3iFIRTSrNKVvEQc1keOFpvhCUIoRB3sp/Q=
Date:   Sun, 14 Mar 2021 08:21:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anton Eidelman <anton@lightbitslabs.com>
Cc:     stable@vger.kernel.org, kbusch@kernel.org, sagi@grimberg.me,
        hch@lst.de
Subject: Re: nvme: ns_head vs namespace mismatch fixes
Message-ID: <YE25hQKxcjHPiFLl@kroah.com>
References: <20210314040035.1357617-1-anton@lightbitslabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210314040035.1357617-1-anton@lightbitslabs.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 13, 2021 at 08:00:33PM -0800, Anton Eidelman wrote:
> *This message is sent in confidence for the addressee 
> only.  It
> may contain legally privileged information. The contents are not 
> to be
> disclosed to anyone other than the addressee. Unauthorized recipients 
> are
> requested to preserve this confidentiality, advise the sender 
> immediately of
> any error in transmission and delete the email from their 
> systems.*
> 

email deleted.
