Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E32122A3D2
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 02:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgGWAqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 20:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733075AbgGWAqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 20:46:18 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1242C0619DC;
        Wed, 22 Jul 2020 17:46:17 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id 72so3212943otc.3;
        Wed, 22 Jul 2020 17:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1tc0sllhtY7w34bXcpMVY0Netptnusq1Em3V/sqHWI0=;
        b=Nlh1gZFqOje/wjQsqdXngrNxRXr5/jM+CCGVx6vQgKOJTZM+IIme1CORg+EAE0xqik
         nQ74StMEiW15q7uL5gjsfhHuqvM8RWH+GkMOaJeGQfO+IBSJJ6UkJ2wXnJgO7saLm9DT
         s2T96qbkRqEJttlsAJMdC6xIBC7R5ip0FiyKddFFn8mc85kuldHRaEaVi+8P27hkoo5J
         sBoMAFOvPh4PkNAf4Zm7KPiGEAMQ/RCHzz3pwJGbNdp8EiajsyR94WKtMLxV5YN45tDa
         9Q14/O+Xb5QZKTF5VtG2S7Osb2ZCqLDHTEjkpRG33RYss9PQ/HfrrbJg31AznsLFOTPQ
         qsFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1tc0sllhtY7w34bXcpMVY0Netptnusq1Em3V/sqHWI0=;
        b=oc8pCocdgJV/yXXHXZ2LEVbbWMQg1eS/JFPBluNbCwYaVTM3gkEJkr9RANoF5nuKkH
         emwMUH0Bm0IC9YBg6z/W26/v3peOxg1gMGvinckS3N/ty52UjuLZcBq41TTWOj78v3uy
         5TjT0gfPoKUsjSW7OL7d9fQ2uu0Hoz4zwdyvde7aNM56t8fsOwoQ2jJtl62VzVPYfucK
         Naj4KPBYQSg1mlE+YfGq/pn12RVffzER/5qx1KHo7vxO3RkqAa3/rtxVQs7w9w0aqkpv
         ZWzygMPWGCCsrsW0Bh1QhwEU9MiF2gsdbXXWbaynS6sB6LMxWEu9bH8wkX/LKyi2582e
         3ECA==
X-Gm-Message-State: AOAM532hLq22vapxnA9B3aTrlvArDEe2Pa04at6R1iODVrZF2BudDMMQ
        dhsW54DElh0ElyVLiTo4m831o2+hZJmuVkD3tzA=
X-Google-Smtp-Source: ABdhPJzqJOiYGRTIoq6oVthPZ4ese3vK8VW1DCnwjbIxJ84GTIETtTPTrzymv2zTBRjQETvttoKPI8msy2SfjIeQNIw=
X-Received: by 2002:a9d:6410:: with SMTP id h16mr2184938otl.168.1595465177143;
 Wed, 22 Jul 2020 17:46:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200722021803.17958-1-hancockrwd@gmail.com> <20200722174009.GA1291928@bjorn-Precision-5520>
In-Reply-To: <20200722174009.GA1291928@bjorn-Precision-5520>
From:   Robert Hancock <hancockrwd@gmail.com>
Date:   Wed, 22 Jul 2020 18:46:06 -0600
Message-ID: <CADLC3L0b8zqJoHt7aA6z6hb3cYC2z-32vmQsQ3tR0gGduC8+-Q@mail.gmail.com>
Subject: Re: [PATCH] PCI: Disallow ASPM on ASMedia ASM1083/1085 PCIe-PCI bridge
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-pci@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        Puranjay Mohan <puranjay12@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 22, 2020 at 11:40 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> [+cc Puranjay]
>
> On Tue, Jul 21, 2020 at 08:18:03PM -0600, Robert Hancock wrote:
> > Recently ASPM handling was changed to no longer disable ASPM on all
> > PCIe to PCI bridges. Unfortunately these ASMedia PCIe to PCI bridge
> > devices don't seem to function properly with ASPM enabled, as they
> > cause the parent PCIe root port to cause repeated AER timeout errors.
> > In addition to flooding the kernel log, this also causes the machine
> > to wake up immediately after suspend is initiated.
>
> Hi Robert, thanks a lot for the report of this problem
> (https://lore.kernel.org/r/CADLC3L1R2hssRjxHJv9yhdN_7-hGw58rXSfNp-FraZh0Tw+gRw@mail.gmail.com
> and https://bugzilla.redhat.com/show_bug.cgi?id=1853960).
>
> I'm pretty sure Linux ASPM support is missing some things.  This
> problem might be a hardware problem where a quirk is the right
> solution, but it could also be that it's a result of a Linux defect
> that we should fix.
>
> Could you collect the dmesg log and "sudo lspci -vvxxxx" output
> somewhere (maybe a bugzilla.kernel.org issue)?  I want to figure out
> whether this L1 PM substates are enabled on this link, and whether
> that's configured correctly.

Created a Bugzilla entry and added dmesg and lspci output:
https://bugzilla.kernel.org/show_bug.cgi?id=208667

As I noted in that report, I subsequently found this page on ASMedia's
site: https://www.asmedia.com.tw/eng/e_show_products.php?cate_index=169&item=114
which indicates this ASM1083 device has "No PCIe ASPM support". It's
not clear why this problem isn't occurring on Windows however - either
it is not enabling ASPM, somehow it doesn't cause issues with the PCIe
link, or it is causing issues and just doesn't notify the user in any
way. I can try and check if this bridge device is ending up with ASPM
enabled under Windows 10 or not..
