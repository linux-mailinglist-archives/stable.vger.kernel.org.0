Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 545FFFE256
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 17:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfKOQKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 11:10:32 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37519 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbfKOQKc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 11:10:32 -0500
Received: by mail-qk1-f196.google.com with SMTP id e187so8522497qkf.4
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 08:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QXQnsuzIdBD4R7XwRkiLdL633g5N2HlkyOWWAExgJGo=;
        b=udqLCFcds+MJ2Y/juBQ9HAl4utewCmMZfse7vGLAKZuboTmXzCedLxYEXt/DXXTZC4
         cl2y/Mf8bkDabGez0Kf6FAWqIKLKrNkIFoTFyKjMjiDUBHqHZy7lV72ftLWBpa1NKv9O
         VmkZ79DKNubg//mSi9AMOyHnOAG6WxSurIJGRzaOuguYmeIWAhyG5WHJIrLyIfIoH13v
         /Qdm2YO9qLLoxV8Iv8g9DYFb1yGQbh6RmUHTm6D5XNMrVWcjJ+Mgeu9/TsklEBdHnXHg
         PE5hYh5xNmiN5EdT/d+5FJlH+v0QwKW0DULKZVFGKU1lo1AIZQ3sNg0MkPJZKBfT52sI
         8A1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QXQnsuzIdBD4R7XwRkiLdL633g5N2HlkyOWWAExgJGo=;
        b=YWQPOf2vKHbByceKvUjWVUqP/CKqhwwIr4OlBfDuGZO5nMiP51QJFTPL74poZz4hGt
         IeQoI0sTpmsqEJamHC5LeCbvhPXGYDKONGcaMYK9gTUFCunf5ZxwQTcIzRwchY08HjqG
         TbsyrYCoGkbj9BfZYC7zBQHbNsskh3WNaouWBGUrG2I15c+KHcVVgDm4zGtwVXD6whGo
         4YhN4YV4hPw/DttcmxonVALpRvSIdKOQLq1wVLmKiyDsR3yyClur6ORHwNYFLDmYRQGS
         OJBWG75wigMvAuXsCuC8ipzTVM2rkjYFm7QQhxOjL89MJd/s/VrKkCp1yVBN9PANIxHU
         xL7g==
X-Gm-Message-State: APjAAAXmThE2vjSnfNp8u4lOdq50nSTchJW+ju41H6Q0JFQbQaEoPtnJ
        WVq1h5ithny2VAEoYTosFk24Fw==
X-Google-Smtp-Source: APXvYqzpikIUfpamKtvZpl4aOMTDjuDVakJhUx8VpGxQ7emrsC+EYMZ4sVhQZWenOPg5pF/S+NpI1w==
X-Received: by 2002:a37:4e03:: with SMTP id c3mr8749809qkb.6.1573834231034;
        Fri, 15 Nov 2019 08:10:31 -0800 (PST)
Received: from localhost (rfs.netwinder.org. [206.248.184.2])
        by smtp.gmail.com with ESMTPSA id 70sm4236561qkj.48.2019.11.15.08.10.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Nov 2019 08:10:30 -0800 (PST)
Date:   Fri, 15 Nov 2019 11:10:29 -0500
From:   Ralph Siemsen <ralph.siemsen@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+899a33dc0fa0dbaf06a6@syzkaller.appspotmail.com,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Jeremy Cline <jcline@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 4.9 02/31] Bluetooth: hci_ldisc: Postpone
 HCI_UART_PROTO_READY bit set in hci_uart_set_proto()
Message-ID: <20191115161029.GA32365@maple.netwinder.org>
References: <20191115062009.813108457@linuxfoundation.org>
 <20191115062010.682028342@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191115062010.682028342@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Nov 15, 2019 at 02:20:31PM +0800, Greg Kroah-Hartman wrote:
>From: Kefeng Wang <wangkefeng.wang@huawei.com>
>
>commit 56897b217a1d0a91c9920cb418d6b3fe922f590a upstream.
>
>task A:                                task B:
>hci_uart_set_proto                     flush_to_ldisc
> - p->open(hu) -> h5_open  //alloc h5  - receive_buf
> - set_bit HCI_UART_PROTO_READY         - tty_port_default_receive_buf
> - hci_uart_register_dev                 - tty_ldisc_receive_buf
>                                          - hci_uart_tty_receive
>				           - test_bit HCI_UART_PROTO_READY
>				            - h5_recv
> - clear_bit HCI_UART_PROTO_READY             while() {
> - p->open(hu) -> h5_close //free h5
>				              - h5_rx_3wire_hdr
>				               - h5_reset()  //use-after-free
>                                              }
>
>It could use ioctl to set hci uart proto, but there is
>a use-after-free issue when hci_uart_register_dev() fail in
>hci_uart_set_proto(), see stack above, fix this by setting
>HCI_UART_PROTO_READY bit only when hci_uart_register_dev()
>return success.
>
>Reported-by: syzbot+899a33dc0fa0dbaf06a6@syzkaller.appspotmail.com
>Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>Reviewed-by: Jeremy Cline <jcline@redhat.com>
>Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I was just about to ask why this had not been merged into 4.9. Spent a 
while searching archives for any discussion to explain its absence, but 
couldn't find anything. Also watched your kernel-recipes talk...

BTW, this also seems to be missing from 4.4 branch, although it was 
merged for 3.16 (per https://lore.kernel.org/stable/?q=Postpone+HCI).

I gather that the usual rule is that a fix must be in newer versions 
before it can go into older ones. Or at least, some patches were 
rejected on that basis. If this is in fact the policy, perhaps it could 
be added to stable-kernel-rules.rst ?

-Ralph

>---
> drivers/bluetooth/hci_ldisc.c |    3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
>--- a/drivers/bluetooth/hci_ldisc.c
>+++ b/drivers/bluetooth/hci_ldisc.c
>@@ -653,15 +653,14 @@ static int hci_uart_set_proto(struct hci
> 		return err;
>
> 	hu->proto = p;
>-	set_bit(HCI_UART_PROTO_READY, &hu->flags);
>
> 	err = hci_uart_register_dev(hu);
> 	if (err) {
>-		clear_bit(HCI_UART_PROTO_READY, &hu->flags);
> 		p->close(hu);
> 		return err;
> 	}
>
>+	set_bit(HCI_UART_PROTO_READY, &hu->flags);
> 	return 0;
> }
>
>
>
