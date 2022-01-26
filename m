Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711EF49CB0C
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 14:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240613AbiAZNli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 08:41:38 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:39293 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231417AbiAZNlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 08:41:37 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3C9B95801EE;
        Wed, 26 Jan 2022 08:41:36 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 26 Jan 2022 08:41:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; bh=b6iL1K2h3uSTLekyPz1hyUnMBJ7XuWG/MXCQRm
        uRNRs=; b=cyZF1hviFaVMW4qEhSwLp14iyu5HsnnGTS1iAcaLLDynWllB1UpZJi
        LZnt1vAITfvEpQJd+pdnnfaGRQB1dJhdL15yReqOtorz+bmN1toG5rqhVBzQUFxn
        ZEogl4LAma/5RBq3+uePt+/MtDjKfH4llzblbInHmGXQtLpRlc048UMiNVjXw+/y
        8w+JI3dr0OTIKYwAIZSlpNrXXTGsTYmP0uglLCmZysBodAIhVQHhvLUIAcNnFMfV
        Zhycj2k/q4TcD9Alc4WoI/XqmUZOBgnyildkzajLHqsmhtUZHUI6OhVf84VbJmVr
        V9NbMHTHqv2f9HOg/zNQRmc0ePmPNJfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=b6iL1K2h3uSTLekyP
        z1hyUnMBJ7XuWG/MXCQRmuRNRs=; b=eyZKEwhOfQexbdKq0S+1jzcaP8UPpzYJ5
        oTqtBccbwFg8hIQA3K6IacbE0FJbw0DnU3as1JlFxnB08ED0vAyhgnm/GwWgvZC5
        o0f+JyqZ91Gs9cJ9UoqYxzQ0o47/ziTRtsw7Yao/qQItuzwP0MKG9zGCiST4FYc7
        z00iOt+uPh8hgyG5qDiKPgj9hliLA6loFUMFNlCZ8s7cNU7CaVz6CL+Be/bP9dVo
        qqUI/N/l+3FGM6Q1qH8YzLYJS7Uh7eiTHSfW8vIv0gCyZIawLtASNfQy0Q2mAadI
        lWdU5fKqBV9s29aMWsP5+sgA+lDMBxeBwgdv6pGwvEiC9CdtOM1hA==
X-ME-Sender: <xms:j0_xYZ0xsUPL2QNymUGxBwzJq_iH-ASdBLceETpcPBlciGtB9n_RRg>
    <xme:j0_xYQFKty-knV0hLhykpTlm3-CRydrs4jJmV9hz4s06wbF92VXkV-49akykLP6Pw
    vFHvuhkeTYDzQ>
X-ME-Received: <xmr:j0_xYZ7A0wvgM04yorZuZiDQ_KvB5c8YsnAq7OSHDH_qJ7Ck5BGgL1aeJJkFzncHWpWu9UBgO2f9CQ7vLc2VZS1oU18mpr4p>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfedugdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:j0_xYW1jwiK94xxT3b5wSQK6QLJyFdwFFYGNrQT01kYMHF9IF6JacQ>
    <xmx:j0_xYcEH2Nyg0mskg_ERQUrW_FQFAHQNXNKpavlfdtNxUvR1tOKCDA>
    <xmx:j0_xYX9PxSMkWKR1j3jN9QgSJooQCYTX_20T8InWHYawiNpXe9AUxQ>
    <xmx:kE_xYfZfkzLFgNgwReF6SuGyXYf6oHer-Cx77zoPpUR2rC_MCY6lLQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Jan 2022 08:41:35 -0500 (EST)
Date:   Wed, 26 Jan 2022 14:41:32 +0100
From:   Greg KH <greg@kroah.com>
To:     Laurent Vivier <laurent@vivier.eu>
Cc:     linux-kernel@vger.kernel.org, linux-rtc@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        John Stultz <john.stultz@linaro.org>, stable@vger.kernel.org
Subject: Re: [PATCH v12 2/5] tty: goldfish: introduce
 gf_ioread32()/gf_iowrite32()
Message-ID: <YfFPjOEELiTWr2uj@kroah.com>
References: <20220121200738.2577697-1-laurent@vivier.eu>
 <20220121200738.2577697-3-laurent@vivier.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121200738.2577697-3-laurent@vivier.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 21, 2022 at 09:07:35PM +0100, Laurent Vivier wrote:
> Revert
> commit da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")

Why?

> and define gf_ioread32()/gf_iowrite32() to be able to use accessors
> defined by the architecture.

What does this do?

> 
> Cc: stable@vger.kernel.org # v5.11+
> Fixes: da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
> Signed-off-by: Laurent Vivier <laurent@vivier.eu>
> ---
>  drivers/tty/goldfish.c   | 20 ++++++++++----------
>  include/linux/goldfish.h | 15 +++++++++++----
>  2 files changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
> index 5ed19a9857ad..10c13b93ed52 100644
> --- a/drivers/tty/goldfish.c
> +++ b/drivers/tty/goldfish.c
> @@ -61,13 +61,13 @@ static void do_rw_io(struct goldfish_tty *qtty,
>  	spin_lock_irqsave(&qtty->lock, irq_flags);
>  	gf_write_ptr((void *)address, base + GOLDFISH_TTY_REG_DATA_PTR,
>  		     base + GOLDFISH_TTY_REG_DATA_PTR_HIGH);
> -	__raw_writel(count, base + GOLDFISH_TTY_REG_DATA_LEN);
> +	gf_iowrite32(count, base + GOLDFISH_TTY_REG_DATA_LEN);
>  
>  	if (is_write)
> -		__raw_writel(GOLDFISH_TTY_CMD_WRITE_BUFFER,
> +		gf_iowrite32(GOLDFISH_TTY_CMD_WRITE_BUFFER,
>  		       base + GOLDFISH_TTY_REG_CMD);
>  	else
> -		__raw_writel(GOLDFISH_TTY_CMD_READ_BUFFER,
> +		gf_iowrite32(GOLDFISH_TTY_CMD_READ_BUFFER,
>  		       base + GOLDFISH_TTY_REG_CMD);
>  
>  	spin_unlock_irqrestore(&qtty->lock, irq_flags);
> @@ -142,7 +142,7 @@ static irqreturn_t goldfish_tty_interrupt(int irq, void *dev_id)
>  	unsigned char *buf;
>  	u32 count;
>  
> -	count = __raw_readl(base + GOLDFISH_TTY_REG_BYTES_READY);
> +	count = gf_ioread32(base + GOLDFISH_TTY_REG_BYTES_READY);
>  	if (count == 0)
>  		return IRQ_NONE;
>  
> @@ -159,7 +159,7 @@ static int goldfish_tty_activate(struct tty_port *port, struct tty_struct *tty)
>  {
>  	struct goldfish_tty *qtty = container_of(port, struct goldfish_tty,
>  									port);
> -	__raw_writel(GOLDFISH_TTY_CMD_INT_ENABLE, qtty->base + GOLDFISH_TTY_REG_CMD);
> +	gf_iowrite32(GOLDFISH_TTY_CMD_INT_ENABLE, qtty->base + GOLDFISH_TTY_REG_CMD);
>  	return 0;
>  }
>  
> @@ -167,7 +167,7 @@ static void goldfish_tty_shutdown(struct tty_port *port)
>  {
>  	struct goldfish_tty *qtty = container_of(port, struct goldfish_tty,
>  									port);
> -	__raw_writel(GOLDFISH_TTY_CMD_INT_DISABLE, qtty->base + GOLDFISH_TTY_REG_CMD);
> +	gf_iowrite32(GOLDFISH_TTY_CMD_INT_DISABLE, qtty->base + GOLDFISH_TTY_REG_CMD);
>  }
>  
>  static int goldfish_tty_open(struct tty_struct *tty, struct file *filp)
> @@ -202,7 +202,7 @@ static unsigned int goldfish_tty_chars_in_buffer(struct tty_struct *tty)
>  {
>  	struct goldfish_tty *qtty = &goldfish_ttys[tty->index];
>  	void __iomem *base = qtty->base;
> -	return __raw_readl(base + GOLDFISH_TTY_REG_BYTES_READY);
> +	return gf_ioread32(base + GOLDFISH_TTY_REG_BYTES_READY);
>  }
>  
>  static void goldfish_tty_console_write(struct console *co, const char *b,
> @@ -355,7 +355,7 @@ static int goldfish_tty_probe(struct platform_device *pdev)
>  	 * on Ranchu emulator (qemu2) returns 1 here and
>  	 * driver will use physical addresses.
>  	 */
> -	qtty->version = __raw_readl(base + GOLDFISH_TTY_REG_VERSION);
> +	qtty->version = gf_ioread32(base + GOLDFISH_TTY_REG_VERSION);
>  
>  	/*
>  	 * Goldfish TTY device on Ranchu emulator (qemu2)
> @@ -374,7 +374,7 @@ static int goldfish_tty_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> -	__raw_writel(GOLDFISH_TTY_CMD_INT_DISABLE, base + GOLDFISH_TTY_REG_CMD);
> +	gf_iowrite32(GOLDFISH_TTY_CMD_INT_DISABLE, base + GOLDFISH_TTY_REG_CMD);
>  
>  	ret = request_irq(irq, goldfish_tty_interrupt, IRQF_SHARED,
>  			  "goldfish_tty", qtty);
> @@ -436,7 +436,7 @@ static int goldfish_tty_remove(struct platform_device *pdev)
>  #ifdef CONFIG_GOLDFISH_TTY_EARLY_CONSOLE
>  static void gf_early_console_putchar(struct uart_port *port, int ch)
>  {
> -	__raw_writel(ch, port->membase);
> +	gf_iowrite32(ch, port->membase);
>  }
>  
>  static void gf_early_write(struct console *con, const char *s, unsigned int n)
> diff --git a/include/linux/goldfish.h b/include/linux/goldfish.h
> index 12be1601fd84..bcc17f95b906 100644
> --- a/include/linux/goldfish.h
> +++ b/include/linux/goldfish.h
> @@ -8,14 +8,21 @@
>  
>  /* Helpers for Goldfish virtual platform */
>  
> +#ifndef gf_ioread32
> +#define gf_ioread32 ioread32
> +#endif
> +#ifndef gf_iowrite32
> +#define gf_iowrite32 iowrite32
> +#endif
> +
>  static inline void gf_write_ptr(const void *ptr, void __iomem *portl,
>  				void __iomem *porth)
>  {
>  	const unsigned long addr = (unsigned long)ptr;
>  
> -	__raw_writel(lower_32_bits(addr), portl);
> +	gf_iowrite32(lower_32_bits(addr), portl);
>  #ifdef CONFIG_64BIT
> -	__raw_writel(upper_32_bits(addr), porth);
> +	gf_iowrite32(upper_32_bits(addr), porth);
>  #endif
>  }
>  
> @@ -23,9 +30,9 @@ static inline void gf_write_dma_addr(const dma_addr_t addr,
>  				     void __iomem *portl,
>  				     void __iomem *porth)
>  {
> -	__raw_writel(lower_32_bits(addr), portl);
> +	gf_iowrite32(lower_32_bits(addr), portl);
>  #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> -	__raw_writel(upper_32_bits(addr), porth);
> +	gf_iowrite32(upper_32_bits(addr), porth);
>  #endif
>  }
>  
> -- 
> 2.34.1
> 

This feels like a step backwards.  Why keep this level of indirection
for no good reason?

thanks,

greg k-h
