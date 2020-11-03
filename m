Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95D72A58B0
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731036AbgKCUpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729594AbgKCUpg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 15:45:36 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BD2C0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 12:45:35 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id c18so3196470ybj.10
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 12:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=geFh77xJVpyw4SGM8y1Nz3j4xELWf2mc3eHynu1XSGw=;
        b=N6ByXxp3gKNzA+SOMouQeQj5S/BY8+cB8Ut90teM6G5tFdTX0gngjp6YDrekDjn+1A
         cM+Qo0rqFSeBv2qqS7W3yCKgB6nrqFzeKMU2pKTehGujVjLbVaIOQMwdRpbOW1LXMD95
         k4maP7D7Wp2UiJ1sB8W094iayYGTg9hre6RaE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=geFh77xJVpyw4SGM8y1Nz3j4xELWf2mc3eHynu1XSGw=;
        b=e+LAyvzZrSjo8osuwbina49DG2MYp6Sob6vMfTGZBDC6OUXu7Ek0MVddf9K+1D4LVl
         RhztTqtJ9qaxZ27OU6nHHFT++PYZGllJPv01gip95cCfhLtUZ+YHLifDSptVS9urdwqi
         OWHTjkyBy3LMu7MZUNMz+ONh9ivfs69pZga4chzhGn6aVP+jYBjEVnBabg6yt9xMzymw
         l2s/9+sRqI5luSX1EON11dWl6MOqxK08b6I6sYx7hZb1aShsv8ok/lRKNgbNWRGw7vIj
         3u5quXz3jN060al77aLiK+Fl4Xz64WzDT0eY0IyCCuM6GNrED7sYg5ATtxuK9XENXucb
         PobQ==
X-Gm-Message-State: AOAM533JpMfAyDuV729fxh6mrGekjL87LtV4C91AxNXa7Drctn9/ryc1
        M/sPZ3w298IN+VuetH9ni2J853qCKFmW9M4B/SCCgQ==
X-Google-Smtp-Source: ABdhPJwz1QeOCBgDQuFlX5A2XoTj3g7LEOBthqyuQMsfIP2mhZOKaR8fcSpymrVeJcv+xSAuP1AMGahOti55vV9GUEk=
X-Received: by 2002:a25:c549:: with SMTP id v70mr28221161ybe.419.1604436334125;
 Tue, 03 Nov 2020 12:45:34 -0800 (PST)
MIME-Version: 1.0
References: <CAABuPhZKJncNoVb3-um8WTdyvffvcYqPKDUA_AcpmEZQrMshTg@mail.gmail.com>
 <CAABuPhZZG13uxa-NpiH1k1HbNYx2QDLEOLURsVnBmu8ynZcaig@mail.gmail.com> <20201103183028.GB83845@kroah.com>
In-Reply-To: <20201103183028.GB83845@kroah.com>
From:   Costa Sapuntzakis <costa@purestorage.com>
Date:   Tue, 3 Nov 2020 12:45:24 -0800
Message-ID: <CAABuPhb-mRsrFjPLeXaObbCEDQX0XWYFOO+xJVTcbQ1W2tqosw@mail.gmail.com>
Subject: Re: Fwd: remove ext4-fix-superblock-checksum-calculation-race.patch ?
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 3, 2020 at 10:30 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Nov 03, 2020 at 09:24:57AM -0800, Costa Sapuntzakis wrote:
> > syzbot found https://syzkaller.appspot.com/bug?extid=7a4ba6a239b91a126c28
> > which shows we can try to sleep under a spinlock in an error path.
>
> Do you have a patch for this?

Sorry, I put too much in the subject. I received e-mail this morning
(Pacific Standard Time) that
ext4-fix-superblock-checksum-calculation-race.patch had been
incorporated into various stable branches. Yesterday, I received an
e-mail from Hillf Danton (hdanton@sina.com) that syzbot had found a
bug in the patch.

Hillf Danton (hdanton@sina.com) has made a patch for the patch and it
is being reviewed.

Best,
-Costa
