Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 100F1586A6
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 18:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfF0QG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 12:06:29 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:45352 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfF0QG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 12:06:29 -0400
Received: by mail-oi1-f195.google.com with SMTP id m206so1955230oib.12
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 09:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aWIMvxomigHpjWeHK43P8bQp7hskbPyoEW4qUC++xwQ=;
        b=vp6g94SZAEhogB8+kASBrS83edW6InCqKko2xuhZZT36olRb9uNCLMVjLyfI6OQkYT
         8otOEjJ/wDda0iFu+AgKq5gR4ZQdNDsgl1cId5NnnL1iJ/GvZXT6HuisMcGOClqUlIDC
         FjGSCO8bQLXY3sOuHvTq/VDGJlZgYzKRP7eKLh/seOIB2ogk0e13lnG4EjwF37n71ps/
         zar5oshbh8IZ1AxD5brAYSbwVO6BQCN0DWQqcd2Fb8iQvPW8X62BL2WBnTS1MxzZQhxg
         ei8ENh0k8ProSrH8xiIDZSOUsBqFhCE5qcGcZDbva8PLP4urG/BUAIMh00/WAaoWm7Us
         XyXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aWIMvxomigHpjWeHK43P8bQp7hskbPyoEW4qUC++xwQ=;
        b=MSIjQf05cqc2n15D0oCbnxsLyZ8yZ3qYFX04QQrkZFcG/ic4dEWJfqyfjadNbKsJs7
         jSigYEbKc38jRel1k4zn1YxqTPPeyFrjx2wuwfTSDlMNNkmcZyunyYdcgDTONN67drSM
         qMr09NdKGoTGEsySGFuLRxpvXUGheNqUKukxoEB2nF1lmVRXyGwVCo15j/174Po4cONG
         TbAWlrrdWYZ+UXpQCiR6OED1OWhhWyJfXdV8Wr9nk/EGg6d3KadUAaPkam9oMA6KhARW
         PAsE5eBdz8rSQVod39jPXGR9ZAGTSJoDcgJWMfvFa8v0QtobgPq+8b+A8nUacXVJKDAO
         H7nw==
X-Gm-Message-State: APjAAAUy08ugAmvmpMzS7cDFBz1tQVSd3DMJaV7uJq9E5gnOyqdHh5AP
        kJF6ZU8IbugJ7EHLmXqszUa0+yrGRI38TxNIwryc2g==
X-Google-Smtp-Source: APXvYqxTBH4M/fPCrgDrZ+VdGZm5oRMIwhu+eQ9E/gvhgkhPtescyRRgvt8+s9jNs39vk0crvfXTrVskZyRmmvNYxVA=
X-Received: by 2002:aca:fc50:: with SMTP id a77mr2695751oii.0.1561651588356;
 Thu, 27 Jun 2019 09:06:28 -0700 (PDT)
MIME-Version: 1.0
References: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190627123415.GA4286@bombadil.infradead.org>
In-Reply-To: <20190627123415.GA4286@bombadil.infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 27 Jun 2019 09:06:17 -0700
Message-ID: <CAPcyv4jQP-SFJGor-Q3VCRQ0xwt3MuVpH2qHx2wzyRA88DGQww@mail.gmail.com>
Subject: Re: [PATCH] filesystem-dax: Disable PMD support
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 27, 2019 at 5:34 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Wed, Jun 26, 2019 at 05:15:45PM -0700, Dan Williams wrote:
> > Ever since the conversion of DAX to the Xarray a RocksDB benchmark has
> > been encountering intermittent lockups. The backtraces always include
> > the filesystem-DAX PMD path, multi-order entries have been a source of
> > bugs in the past, and disabling the PMD path allows a test that fails in
> > minutes to run for an hour.
>
> On May 4th, I asked you:
>
> Since this is provoked by a fatal signal, it must have something to do
> with a killable or interruptible sleep.  There's only one of those in the
> DAX code; fatal_signal_pending() in dax_iomap_actor().  Does rocksdb do
> I/O with write() or through a writable mmap()?  I'd like to know before
> I chase too far down this fault tree analysis.

RocksDB in this case is using write() for writes and mmap() for reads.
