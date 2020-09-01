Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1843A258FB4
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 15:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgIAN7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 09:59:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728237AbgIAN6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 09:58:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3BAE206FA;
        Tue,  1 Sep 2020 13:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598968680;
        bh=PICfr82+/CFa8DSnNDrsaM/M3p7sKLGeZtPFYVvkFkU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OPpK8iJdHFO6YnBCe7HFSxtZOsD/Kg410cd/4IsRdTadtnzbnJgSbHY4Qq6r1kL2H
         J9pXT0YFsnSQXF2L9FiY5imc4GDkgk7ux3gW1tqvrbQpj888rkQOLliuJv4nmFxJmV
         rfEmXcZBU6NgXHgUqWeSR3uF+s+jw7ygnQ6alrW8=
Date:   Tue, 1 Sep 2020 15:58:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Denis Efremov <efremov@linux.com>
Cc:     Matthias Maennich <maennich@google.com>, stable@vger.kernel.org,
        kernel-team@android.com,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH v5.4 6/6] kbuild: add variables for compression tools
Message-ID: <20200901135827.GB397411@kroah.com>
References: <20200826162828.3330007-1-maennich@google.com>
 <20200826162828.3330007-7-maennich@google.com>
 <4916bb81-e9d3-8425-ceeb-7e9321068848@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4916bb81-e9d3-8425-ceeb-7e9321068848@linux.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26, 2020 at 10:07:17PM +0300, Denis Efremov wrote:
> Hi,
> 
> This patch introduces build error, see fix:
> e4a42c82e943 kbuild: fix broken builds because of GZIP,BZIP2,LZOP variables

Thanks for that, I've picked it up now.

greg k-h
