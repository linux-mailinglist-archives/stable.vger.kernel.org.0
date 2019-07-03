Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22EBF5E06A
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 11:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfGCJBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 05:01:22 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43404 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbfGCJBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 05:01:22 -0400
Received: by mail-ot1-f65.google.com with SMTP id q10so1538654otk.10;
        Wed, 03 Jul 2019 02:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nqsl7mw8i2F0KpVu3YClsX9awvB+a3f/6kMjL+tSEX0=;
        b=NBlReOsCEysqP0tKzR7+2SoIMgPZQTbMxjMN3O689cupA+zJC9X7NQ9JzYy95V7Zth
         khffgZXpyEMVM9zQmRz9cELHlokp1YbTApLv0wpoXlMIcymKqHW183DDIzGRb/9w7Eds
         QDyARb5iMwDqaKh7m8vX0dkpF+XaJvTBDxFerSPzoZa0Gtnt0srZuDrTT9q6cBr45SCe
         F8ec5gQqYMTm0jd/rVyPy2xD96AkVQXxthY83d+xzkJoVG/W01+yvxMG1aIdjSopExuN
         VzXRIhGajp86xxbkNMiSKFJ6G0U3OS1Ncv5k71aGEdus+ltgEb7BfANujqZwT2nKNIeB
         tGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nqsl7mw8i2F0KpVu3YClsX9awvB+a3f/6kMjL+tSEX0=;
        b=tAGSAqRlQs/5dXLBvu1Sqcdh0LdjKBghXrIU4GfGy1TuernubL7xiXI0FYWUJBjyxd
         tCfm7PTulBd3arRNHaiSmBVXgLg4bRruZ9pTLSib9lvPlWKsdqjsd5hPKk4YmlK/A2lw
         2VRrJZyIOZZPXNqc7JQsbyBCI3LAfFcVWkoQMdT0blc35ayRrD8B7Iy6MRM3hZraxliG
         b0QVNJhDQAhAOeuEuSsbwor4uj3daGqteRzKa1lbvNDVyYDv+b9DaqibiIXCeqfhOCYE
         Tho0HRRvgBoV9+tF4ObcMdxy31U5GwvcnY0Myh6wDS9ZmTNSJbDMcP1tQoxEkVj+6MDC
         dIiw==
X-Gm-Message-State: APjAAAWR+iJCpQuJrURwkGfa6p0uV9G8zStj0iitkGu358ZrYt4MmhhG
        GOlgA5nfz/YFsvBR1LeYpnfiooRTczcLJP3/qSw=
X-Google-Smtp-Source: APXvYqy8nQfsCP9N5UeSronAuP31jlfLFowq8I3R9eP1zf8A8FBjZ25PU/l0s1nJ98KQZ2Cjy6gP0Ktnt+omp6h1XMI=
X-Received: by 2002:a9d:226c:: with SMTP id o99mr27126789ota.42.1562144481370;
 Wed, 03 Jul 2019 02:01:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190620175022.29348-1-martin.blumenstingl@googlemail.com>
 <a7647aea-b3e6-b785-8476-1851f50beff1@synopsys.com> <CAFBinCDDyG_CxW+PB_OrUXfy-aDKSoewC2OyCfGh18N=omSgcQ@mail.gmail.com>
In-Reply-To: <CAFBinCDDyG_CxW+PB_OrUXfy-aDKSoewC2OyCfGh18N=omSgcQ@mail.gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 3 Jul 2019 11:01:10 +0200
Message-ID: <CAFBinCD1qj8sNXOK2Pcbz1MAcdvwywPSxQeERNVpmNw=Gmz=Vw@mail.gmail.com>
Subject: Re: [PATCH] usb: dwc2: use a longer AHB idle timeout in dwc2_core_reset()
To:     "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>
Cc:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 1, 2019 at 7:54 PM Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
>
> On Mon, Jun 24, 2019 at 7:41 AM Minas Harutyunyan
> <Minas.Harutyunyan@synopsys.com> wrote:
> >
> > On 6/20/2019 9:51 PM, Martin Blumenstingl wrote:
> > > Use a 10000us AHB idle timeout in dwc2_core_reset() and make it
> > > consistent with the other "wait for AHB master IDLE state" ocurrences.
> > >
> > > This fixes a problem for me where dwc2 would not want to initialize when
> > > updating to 4.19 on a MIPS Lantiq VRX200 SoC. dwc2 worked fine with
> > > 4.14.
> > > Testing on my board shows that it takes 180us until AHB master IDLE
> > > state is signalled. The very old vendor driver for this SoC (ifxhcd)
> > > used a 1 second timeout.
> > > Use the same timeout that is used everywhere when polling for
> > > GRSTCTL_AHBIDLE instead of using a timeout that "works for one board"
> > > (180us in my case) to have consistent behavior across the dwc2 driver.
> > >
> > > Cc: linux-stable <stable@vger.kernel.org> # 4.19+
> > > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > > ---
> >
> > Acked-by: Minas Harutyunyan <hminas@synopsys.com>
> thank you for reviewing this!
>
> is there any chance we can get this fix into Linux 5.3? I know that
> it's too late for 5.2 so I'm fine with skipping that.
thank you Felipe for queuing this for v5.3!
for reference, this patch is now in the usb-for-v5.3-part2 tag: [0]


[0] https://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git/commit/?h=usb-for-v5.3-part2&id=dfc4fdebc5d62ac4e2fe5428e59b273675515fb2
