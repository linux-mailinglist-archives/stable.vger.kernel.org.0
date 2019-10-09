Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6A3D0550
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 03:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfJIBqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 21:46:53 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44163 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfJIBqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 21:46:53 -0400
Received: by mail-io1-f66.google.com with SMTP id w12so1300849iol.11
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 18:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=7w5H/s2/kFfAfXTG+mvswQfIMCIqAqz+8h+M1opFX9w=;
        b=hSf0MNgt+S//vp0jYGrVtfJN//sWtYkAxhmEkc1VGumERBrxfz89+g84dpev4gWuyi
         xYCXeh73AcPMMBsx1sH/fOghL+mbYTk9YFS2crhTbANoEabkRwf6UKjhwivcxanu1phW
         YBofQLj8orvOuz+vlvymC3YpyyLtdp4/hVGYlPp26ykBtzeFcPLM6HfywjIoDz0plSqP
         on1kqsF/nGs58P0+DETkEw6G1Axi63iGi2JiBp+XtL2NqaJkgf70eUbIv2gDu7Hjin7h
         QY+G5HfBxJduyRh8HXjhZsE/wV8oQSZgfcL6JuzsttoJccTPynVD5QjMyFUkMf89SmXQ
         cu6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=7w5H/s2/kFfAfXTG+mvswQfIMCIqAqz+8h+M1opFX9w=;
        b=L+bbUBblZZBWdbA+JEfOeK4BylOsL6gM33jWUMyqe/T7WX4qyY7t1ZgTlZBcqPdnvw
         aho2qmEMsVjVFOhdBxUhrrVUuKv4HZ0UbKcJGMCoKpCvNwUxqxDbetUR6jGewi0Ehu5U
         30sGoa0Um1L82WnQAuMKHlb/j0hTobiGlgx0z0Wr0YHJ3lF5tlf/oQ5LODGEe6GyTpcL
         Cj8N87RR9fCztHR/YHnGqIane29rmQYDQeYqz7mP1lFraF7cO2Xol5cJZ2vFTx1xl8VE
         KTvSAdDedB3dcxy1eJMBIfT+Yznxmob1iRwjPHofXY0/EIvN7ufMAowmVxGRKLL73c2s
         h1+g==
X-Gm-Message-State: APjAAAWez0U4NuhODc+SUNYvIRef0ZugisNyyWFlasQZEJCK15UAdqhy
        xTMaOYITpO07IZQQX4ZQuVfMDg==
X-Google-Smtp-Source: APXvYqxvXr1LrH5IqThXu8IWA35x0j+Xk0PgeazOMTCOfSsRNyU8gG98NmeNwgAH1DjsSvKatekXzg==
X-Received: by 2002:a92:8d19:: with SMTP id s25mr850037ild.18.1570585612331;
        Tue, 08 Oct 2019 18:46:52 -0700 (PDT)
Received: from localhost ([64.62.168.194])
        by smtp.gmail.com with ESMTPSA id m11sm376315ioj.88.2019.10.08.18.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 18:46:51 -0700 (PDT)
Date:   Tue, 8 Oct 2019 18:46:49 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Sasha Levin <sashal@kernel.org>
cc:     gregkh@linuxfoundation.org, vincent.chen@sifive.com,
        david.abdurachmanov@sifive.com, palmer@sifive.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] riscv: Avoid interrupts being erroneously
 enabled in" failed to apply to 5.3-stable tree
In-Reply-To: <20191009012335.GR1396@sasha-vm>
Message-ID: <alpine.DEB.2.21.9999.1910081846370.27413@viisi.sifive.com>
References: <1570555664182195@kroah.com> <20191009005252.GQ1396@sasha-vm> <alpine.DEB.2.21.9999.1910081759550.972@viisi.sifive.com> <20191009012335.GR1396@sasha-vm>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 8 Oct 2019, Sasha Levin wrote:

> On Tue, Oct 08, 2019 at 06:00:36PM -0700, Paul Walmsley wrote:
> > On Tue, 8 Oct 2019, Sasha Levin wrote:
> > 
> > > I might be missing something here, but wasn't the label "1" already
> > > declared a few lines above?
> > 
> > See the "Local Labels" section of
> > 
> > https://sourceware.org/binutils/docs-2.24/as/Symbol-Names.html#Symbol-Names
> 
> Thanks!
> 
> I've fixed the patch to compensate for not having 4f3f90084673f ("riscv:
> Using CSR numbers to access CSRs") and queued it for 5.4 and 4.19.

Thanks Sasha!  You just saved me some time :-)

- Paul
