Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8175F1D6D74
	for <lists+stable@lfdr.de>; Sun, 17 May 2020 23:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgEQV20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 May 2020 17:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgEQV20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 May 2020 17:28:26 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5689C061A0C
        for <stable@vger.kernel.org>; Sun, 17 May 2020 14:28:25 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id fb16so3778508qvb.5
        for <stable@vger.kernel.org>; Sun, 17 May 2020 14:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hR8L+XxeH3eijW5vNzyrWdQNDdMZfBNndiSBWjJ9E9Y=;
        b=k5SQL9l64XRJm084jCUKZf8PbsK9aKPWl4wq4kHcJk6GpH0dL2cQY4E2rr24QBTto5
         vxFGhb1Jo7MaSZ2SJTXbBj2OH+DW1VEQrrAbtreWtXC6yFEHlZNr0+gSru0t7b5aHUDC
         +3X7r0eDj7B+eAlX1/pVw+1zUKzCfvAUDUMjL1BikivT+7rz8lcfKkSPfxXWXgo2iAII
         BMOkFOiV4uMV0EBz9yhay+lBomjVL0QV3U7knqgxKky34FvIhMMj3R6a6tbqytKwOiOr
         EDixRJxY7LZUtJPcRamwbqjUFq6myCfZQ8uE5Hrc/1YXr5x1V5s0/9E/JIRz6VKUubjQ
         xQdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hR8L+XxeH3eijW5vNzyrWdQNDdMZfBNndiSBWjJ9E9Y=;
        b=r4Neyev0JJQirySVJOhmxkY9gg3OYNPiezJIyV2vJ8Oj4qWnCAEhc5pByyeBkWkXuQ
         Lzy+4j4o1C6BTM0xsyTJTOowudswuR2tZHw/MRkC4v4DLvh7rL1wq+3Eztow1rYP+mUQ
         Zf13ukM2Kt9A2352KUDHNIUNu8eW1kg2MmzrNPzWoHZLJsazL2YEFFeiNBC2uBH4loYm
         3kFWVyXmAZf+aNoJRT7SeTuVulHeQlorkIUmMBOeeWjzZy5rpWvGwu4pf1+3rFn+MHb6
         n5t54W6hWPY+VMvEkzLn5FaS5TBl9q9y/NZhukk136HO907dT7pIJVkU+fUe18MTJ0z0
         jcWA==
X-Gm-Message-State: AOAM53133UlkCuxzhv9daTHdf5qFwu7v4h73pR+UCUf3oNfirYenloY0
        s0KuPJvchUIQ0zGcO+i3kgVIkuq09wMaj92nNYI=
X-Google-Smtp-Source: ABdhPJy76x1/A9z4b36Wr9pYv62HSn+NArnOEG9qqCSPVmVnSjPcgL1AJZoP11JnTLCCROQslCNA/Cinc8vpFj8Jads=
X-Received: by 2002:a05:6214:1265:: with SMTP id r5mr12686299qvv.171.1589750905120;
 Sun, 17 May 2020 14:28:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200513131029.15603-1-miquel.raynal@bootlin.com> <20200513180943.63efe337@collabora.com>
In-Reply-To: <20200513180943.63efe337@collabora.com>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Sun, 17 May 2020 23:28:13 +0200
Message-ID: <CAFLxGvw1L=VfvcBXo05EOPKPRk=yknzOUB0zoQ=-r=XCAce4vg@mail.gmail.com>
Subject: Re: [PATCH resend] mtd: spinand: Propagate ECC information to the MTD structure
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        stable <stable@vger.kernel.org>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 6:09 PM Boris Brezillon
<boris.brezillon@collabora.com> wrote:
>
> On Wed, 13 May 2020 15:10:29 +0200
> Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> > This is done by default in the raw NAND core (nand_base.c) but was
> > missing in the SPI-NAND core. Without these two lines the ecc_strength
> > and ecc_step_size values are not exported to the user through sysfs.
> >
> > This fix depends on recent changes and should not be backported as-is.
> >
> > Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

Applied, thanks!

-- 
Thanks,
//richard
