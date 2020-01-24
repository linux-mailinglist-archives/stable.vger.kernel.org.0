Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C10147701
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 03:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgAXCwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 21:52:24 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33229 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730177AbgAXCwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 21:52:24 -0500
Received: by mail-pj1-f67.google.com with SMTP id m7so237085pjs.0
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 18:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+Jtje9PzdEFeKTXOcqQTD8adTbqITK8jdsG/R2A7AX8=;
        b=JFRg77kCHY7BV5hfbYDprPhohNPs2OasesHM0M5Htda7XBUsY4XcUNquAXDlwSzMdd
         u/uSwCEgyJcbrUnZ2n0jBbtr2qFg0BUlZQh95U/iqPHxqf+RZ27Kh0nn1zsvHbdl/B5t
         qBmGDZQaCO9O0wVcBWvt34bGvY/O4vZ2rlyMF4t2WmjT5wtUwrLAtF3X4ye0C8NgxpQd
         ZkNH8Cvu3UjCCBl2h94e2aNiFhBW5jXGeonrXlshNGwRu3WR/Otb8PnMHSnGvN5hqiUk
         Zxre/fjgiBqEQaaow4koVxgu/zlhlcBk4LwnyOlvlL8dJmCNDR2JHhGeMLq/YLFZuVGF
         n7XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+Jtje9PzdEFeKTXOcqQTD8adTbqITK8jdsG/R2A7AX8=;
        b=XReXlpGVL80VK7O2okA2mjWV9vtvX3OEqEVjAzqWB4Vd43RM6iedTYUhMk1PrDhqzX
         /Wq2S30bA7wuiUzhz5rNBXkfgqOay1dHHUqqNlDZN3UvxiQLm6R/940jK4RGkntt094D
         LmexdRlK8DJDc6A7KFFNAtv0/gWDsYCb3QbwzbpIiw72z+MuNgoFtXKNqI8MKTRf62Gg
         crD2PFmkfyB46D4cbQCtVfVCApxhevdRh4bvu/BMTfgkZcbburz7E8Uj9VM3Aify4s6C
         B2RzW9NZiAaay0D7hLin9KOaoXhu7o0wYGgjxX6Nsj8ai+P/A9yqw3s9UOMW3d3llUGT
         io/Q==
X-Gm-Message-State: APjAAAX03rtI1mUlEAW9gYZjLDxnUyHcVfGaVaunYLO4uHmGe0wV9C9v
        kJMuoEmQKEfNnhdcmaV58OdC/g==
X-Google-Smtp-Source: APXvYqzWQ2DtSK2CwiuWk6fQuD8WmyvfPzVBXvCYBm2swLW8wy6vd/uPMq/EqmZRVV6NZU9oGOuJEQ==
X-Received: by 2002:a17:90a:c389:: with SMTP id h9mr910062pjt.128.1579834343395;
        Thu, 23 Jan 2020 18:52:23 -0800 (PST)
Received: from ziepe.ca ([216.9.110.1])
        by smtp.gmail.com with ESMTPSA id i127sm4094711pfe.54.2020.01.23.18.52.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Jan 2020 18:52:22 -0800 (PST)
Received: from jgg by jggl.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iup53-0004Hr-BB; Thu, 23 Jan 2020 22:52:21 -0400
Date:   Thu, 23 Jan 2020 22:52:21 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Gal Pressman <galpress@amazon.com>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Alexander Matushevsky <matua@amazon.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Leybovich, Yossi" <sleybo@amazon.com>
Subject: Re: [PATCH for-rc] Revert "RDMA/efa: Use API to get contiguous
 memory blocks aligned to device supported page size"
Message-ID: <20200124025221.GA16405@ziepe.ca>
References: <20200120141001.63544-1-galpress@amazon.com>
 <0557a917-b6ad-1be7-e46b-cbe08f2ee4d3@amazon.com>
 <20200121162436.GL51881@unreal>
 <47c20471-2251-b93b-053d-87880fa0edf5@amazon.com>
 <20200123142443.GN7018@unreal>
 <60d8c528-1088-df8d-76f0-4746acfcfc7a@amazon.com>
 <9DD61F30A802C4429A01CA4200E302A7C57244BB@fmsmsx123.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7C57244BB@fmsmsx123.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 12:40:18AM +0000, Saleem, Shiraz wrote:
> It would be good to get the debug data to back this or prove it wrong.
> But if this is indeed what's happening, then ORing in the sgl->length for the
> first sge to restrict the page size might cut it. So something like,

or'ing in the sgl length is a nonsense thing to do, the length has
nothing to do with the restriction, which is entirely based on IOVA
bits which can't be passed through.

Jason
