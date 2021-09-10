Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88FC4070A6
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 19:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhIJRsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 13:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbhIJRsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 13:48:03 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD054C061756
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 10:46:51 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id am9so2544960ejc.7
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 10:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IgWBO3Uv9OBhCwBG8vrFyyijHoDLNm3JMHSrjA1m4d8=;
        b=XY8cCc3ccfQuqITVPZKEVJENTylrP0bm3hfzg/071pJ3z57Ovb6Z4jBpg3l0jHjFez
         v5fvEjI3t6gWhouiuxBKNwltOiokgasQvdwSPafa0PKvnwQ1j/y0QvvYBmw1oGuGHtkX
         yoiU3faPL1nLPr/J+0dlpc3ZszH0v/3HvqjAuUhz6vVlYw0nQthe9oTO1WPvkbkS/BrO
         9D/yONYnh6X22yo+9v03LtTFiaDajcILbE/PAyIx8RSPyFbO3qBjBZm3jL7KFispLqVD
         aoRLkS5LNCRiQQF4wqnePFNIZlXGb2eL0XfUUm0Ag0Uk+lyEuzlpxo/rY2wf/GMKy30z
         TPbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IgWBO3Uv9OBhCwBG8vrFyyijHoDLNm3JMHSrjA1m4d8=;
        b=rQgQ71cyw3HqLGw4gfoAjBNfrIWT3lNmXkrNhLCFQqx9vRLeVfbuQENXffta2DK2T6
         glc7nes8uljpU5QjvujhNhcWzpPJnEEjstQyxTOwvO7IImsczfAOpwy9m2GNQX0E7jri
         faXR6ykzMHd7oI3Sxs6/fLgKLFzMHuMh/j7W8b2m4NJItBCElLXs3J/iyahthQMB4ks8
         zOTJp3i3IlUpJFVZXWB4I55boyUypYYcwUVYBJuPWtGxZWn2chGIs14nvRj56iaN6sPm
         U6hFFvyRUIkU6CMKYCG4xsLFOmLUys7TvcBp3k69KZaXucoTmq2N1WvHVGOya1xX3f0t
         aHkg==
X-Gm-Message-State: AOAM530QOaiTjjy3Qp3TzVQvwt541FKRmSpfX8njnECY8Glt2RIbQp/3
        lt3vmE1XIBCE4Pp4Dz0WieTYvgL19U2fWa9vBaDcoF5ImQ==
X-Google-Smtp-Source: ABdhPJyV4xLiAbcfLLKEYf7PEqfauqat1zMHSc2hlfKLjsRENAKUgQD4yxDupel9mDWlsLPIj9tZrVQM41UBekdsiF4=
X-Received: by 2002:a17:906:f15:: with SMTP id z21mr10455115eji.177.1631296010371;
 Fri, 10 Sep 2021 10:46:50 -0700 (PDT)
MIME-Version: 1.0
References: <163072203373.2250120.8373702699578427249.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163072204525.2250120.16615792476976546735.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHC9VhTNu8E9WkzUHbQC9xKK5U74L8oqetUtPXGX2RSofMcqgw@mail.gmail.com>
 <CAPcyv4gR+WbYf-dT0niT23UY8jZZVBXMk4R-1_0exPcbHrs=0Q@mail.gmail.com>
 <CAHC9VhTo-eV4oUF-ia67X-KK-qyB=M0xDv-=p0-xA-4=0BJ6uA@mail.gmail.com> <CAFqZXNvSu2-nL8YEfKhEdT9csm1=nxecoo31FF+jgwyCVdjPMw@mail.gmail.com>
In-Reply-To: <CAFqZXNvSu2-nL8YEfKhEdT9csm1=nxecoo31FF+jgwyCVdjPMw@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 10 Sep 2021 13:46:40 -0400
Message-ID: <CAHC9VhR3_yC4YcuK1qRuU2Rq=bOq7Y4=E16qcF9zBT0khvy6bQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] cxl/pci: Fix lockdown level
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org,
        Ben Widawsky <ben.widawsky@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        stable <stable@vger.kernel.org>,
        "Schofield, Alison" <alison.schofield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 10, 2021 at 8:55 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> And I can see the patch is now in Linus' tree, so if Paul agrees I'll
> rebase the patch on top of v5.15-rc1 once it's tagged ...

Please do, thanks.

-- 
paul moore
www.paul-moore.com
