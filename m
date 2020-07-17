Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBD62243DA
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 21:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgGQTJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 15:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbgGQTJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 15:09:20 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BEBC0619D2
        for <stable@vger.kernel.org>; Fri, 17 Jul 2020 12:09:20 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f18so18740680wml.3
        for <stable@vger.kernel.org>; Fri, 17 Jul 2020 12:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=/UwwbEO31JzWlxVDesKcj2Uig1rl25e7gpMnEAJZlHk=;
        b=NtcD0AV61oUWC+RH/APD49gbMw5tQR68QWkcDSkAsdwtPDuI2/0o5++LjciNqFWxxw
         vviFRfll6shJzfScdC0jhtTaXB6Zuev5yJvEs1IekKAGFT7ER1iNhvpeMUtdND3ZQvwJ
         hupxDZp7ckwJ+xdPl2eMXB3Fvs6GTG8fkSQaQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/UwwbEO31JzWlxVDesKcj2Uig1rl25e7gpMnEAJZlHk=;
        b=mDRlgZzjb90evg9KjZHpNo91qYeWJFLj7dmq0sEbaNLKmo/1H73CABQdHUkM8KWmV4
         2Hd8MFRxJb2xktFtg9C4wb5v/ddxW5zyuZ4cSvWRESyFBJ2WCWn/aSJthsLXAcSBKFiy
         j/sZ41tBq2//FqdIS2qQvr/AyiORLwD9zwjA4NEcp3YDCso41tESfbF11ywEYJlAqA4j
         yTQNWN6sVzwLmL9Re0zHbDtXBuN8+xXm3ov/+xR15GWREslHj4OJZElxGZn+6RBgFaVu
         L1l097g5uT1aBn3a5dgeIR0AmagPZuprUS9obuO5FDrlP/TzCTsU5eAh7eFAxrO6wdYt
         /nXg==
X-Gm-Message-State: AOAM533Fx4s1DM+B7oX4jHfj9OF6/hbZgkVw54PLZw8gwNbtqSNb4pKG
        XCMtcT3q7A/XQTnGnHrKoQ4uXg==
X-Google-Smtp-Source: ABdhPJyZZOy616iG3iWzKwu2GQUAX6FSY9CFeooc2IGFznGVhRF6ATFrlCPVaT9bxQx59r4M9X3NeA==
X-Received: by 2002:a05:600c:2144:: with SMTP id v4mr11364035wml.128.1595012958784;
        Fri, 17 Jul 2020 12:09:18 -0700 (PDT)
Received: from [10.136.13.65] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id 68sm2817078wra.39.2020.07.17.12.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 12:09:18 -0700 (PDT)
Subject: Re: [PATCH 02/13] fs/kernel_read_file: Remove
 FIRMWARE_PREALLOC_BUFFER enum
To:     Kees Cook <keescook@chromium.org>
Cc:     stable@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>,
        Matthew Wilcox <willy@infradead.org>,
        James Morris <jmorris@namei.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jessica Yu <jeyu@kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Garrett <matthewgarrett@google.com>,
        David Howells <dhowells@redhat.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        KP Singh <kpsingh@google.com>, Dave Olsthoorn <dave@bewaar.me>,
        Hans de Goede <hdegoede@redhat.com>,
        Peter Jones <pjones@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20200717174309.1164575-1-keescook@chromium.org>
 <20200717174309.1164575-3-keescook@chromium.org>
From:   Scott Branden <scott.branden@broadcom.com>
Message-ID: <5203c5a1-1ced-f6b1-1086-df65479901a9@broadcom.com>
Date:   Fri, 17 Jul 2020 12:09:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717174309.1164575-3-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020-07-17 10:42 a.m., Kees Cook wrote:
> FIRMWARE_PREALLOC_BUFFER is a "how", not a "what", and confuses the LSMs
> that are interested in filtering between types of things. The "how"
> should be an internal detail made uninteresting to the LSMs.
>
> Fixes: a098ecd2fa7d ("firmware: support loading into a pre-allocated buffer")
> Fixes: fd90bc559bfb ("ima: based on policy verify firmware signatures (pre-allocated buffer)")
> Fixes: 4f0496d8ffa3 ("ima: based on policy warn about loading firmware (pre-allocated buffer)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Scott Branden <scott.branden@broadcom.com>
> ---
> To aid in backporting, this change is made before moving
> kernel_read_file() to separate header/source files.
> ---
>   drivers/base/firmware_loader/main.c | 5 ++---
>   fs/exec.c                           | 7 ++++---
>   include/linux/fs.h                  | 2 +-
>   kernel/module.c                     | 2 +-
>   security/integrity/digsig.c         | 2 +-
>   security/integrity/ima/ima_fs.c     | 2 +-
>   security/integrity/ima/ima_main.c   | 6 ++----
>   7 files changed, 12 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
> index ca871b13524e..c2f57cedcd6f 100644
> --- a/drivers/base/firmware_loader/main.c
> +++ b/drivers/base/firmware_loader/main.c
> @@ -465,14 +465,12 @@ fw_get_filesystem_firmware(struct device *device, struct fw_priv *fw_priv,
>   	int i, len;
>   	int rc = -ENOENT;
>   	char *path;
> -	enum kernel_read_file_id id = READING_FIRMWARE;
>   	size_t msize = INT_MAX;
>   	void *buffer = NULL;
>   
>   	/* Already populated data member means we're loading into a buffer */
>   	if (!decompress && fw_priv->data) {
>   		buffer = fw_priv->data;
> -		id = READING_FIRMWARE_PREALLOC_BUFFER;
>   		msize = fw_priv->allocated_size;
>   	}
>   
> @@ -496,7 +494,8 @@ fw_get_filesystem_firmware(struct device *device, struct fw_priv *fw_priv,
>   
>   		/* load firmware files from the mount namespace of init */
>   		rc = kernel_read_file_from_path_initns(path, &buffer,
> -						       &size, msize, id);
> +						       &size, msize,
> +						       READING_FIRMWARE);
>   		if (rc) {
>   			if (rc != -ENOENT)
>   				dev_warn(device, "loading %s failed with error %d\n",
> diff --git a/fs/exec.c b/fs/exec.c
> index e6e8a9a70327..2bf549757ce7 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -927,6 +927,7 @@ int kernel_read_file(struct file *file, void **buf, loff_t *size,
>   {
>   	loff_t i_size, pos;
>   	ssize_t bytes = 0;
> +	void *allocated = NULL;
>   	int ret;
>   
>   	if (!S_ISREG(file_inode(file)->i_mode) || max_size < 0)
> @@ -950,8 +951,8 @@ int kernel_read_file(struct file *file, void **buf, loff_t *size,
>   		goto out;
>   	}
>   
> -	if (id != READING_FIRMWARE_PREALLOC_BUFFER)
> -		*buf = vmalloc(i_size);
> +	if (!*buf)
> +		*buf = allocated = vmalloc(i_size);
>   	if (!*buf) {
>   		ret = -ENOMEM;
>   		goto out;
> @@ -980,7 +981,7 @@ int kernel_read_file(struct file *file, void **buf, loff_t *size,
>   
>   out_free:
>   	if (ret < 0) {
> -		if (id != READING_FIRMWARE_PREALLOC_BUFFER) {
> +		if (allocated) {
>   			vfree(*buf);
>   			*buf = NULL;
>   		}
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 3f881a892ea7..95fc775ed937 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2993,10 +2993,10 @@ static inline void i_readcount_inc(struct inode *inode)
>   #endif
>   extern int do_pipe_flags(int *, int);
>   
> +/* This is a list of *what* is being read, not *how*. */
>   #define __kernel_read_file_id(id) \
>   	id(UNKNOWN, unknown)		\
>   	id(FIRMWARE, firmware)		\
> -	id(FIRMWARE_PREALLOC_BUFFER, firmware)	\
>   	id(FIRMWARE_EFI_EMBEDDED, firmware)	\
>   	id(MODULE, kernel-module)		\
>   	id(KEXEC_IMAGE, kexec-image)		\
> diff --git a/kernel/module.c b/kernel/module.c
> index 0c6573b98c36..26105148f4d2 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3988,7 +3988,7 @@ SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
>   {
>   	struct load_info info = { };
>   	loff_t size;
> -	void *hdr;
> +	void *hdr = NULL;
>   	int err;
>   
>   	err = may_init_module();
> diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
> index e9cbadade74b..ac02b7632353 100644
> --- a/security/integrity/digsig.c
> +++ b/security/integrity/digsig.c
> @@ -169,7 +169,7 @@ int __init integrity_add_key(const unsigned int id, const void *data,
>   
>   int __init integrity_load_x509(const unsigned int id, const char *path)
>   {
> -	void *data;
> +	void *data = NULL;
>   	loff_t size;
>   	int rc;
>   	key_perm_t perm;
> diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
> index e3fcad871861..15a44c5022f7 100644
> --- a/security/integrity/ima/ima_fs.c
> +++ b/security/integrity/ima/ima_fs.c
> @@ -272,7 +272,7 @@ static const struct file_operations ima_ascii_measurements_ops = {
>   
>   static ssize_t ima_read_policy(char *path)
>   {
> -	void *data;
> +	void *data = NULL;
>   	char *datap;
>   	loff_t size;
>   	int rc, pathlen = strlen(path);
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index c1583d98c5e5..f80ee4ce4669 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -611,19 +611,17 @@ void ima_post_path_mknod(struct dentry *dentry)
>   int ima_read_file(struct file *file, enum kernel_read_file_id read_id)
>   {
>   	/*
> -	 * READING_FIRMWARE_PREALLOC_BUFFER
> -	 *
>   	 * Do devices using pre-allocated memory run the risk of the
>   	 * firmware being accessible to the device prior to the completion
>   	 * of IMA's signature verification any more than when using two
> -	 * buffers?
> +	 * buffers? It may be desirable to include the buffer address
> +	 * in this API and walk all the dma_map_single() mappings to check.
>   	 */
>   	return 0;
>   }
>   
>   const int read_idmap[READING_MAX_ID] = {
>   	[READING_FIRMWARE] = FIRMWARE_CHECK,
> -	[READING_FIRMWARE_PREALLOC_BUFFER] = FIRMWARE_CHECK,
>   	[READING_MODULE] = MODULE_CHECK,
>   	[READING_KEXEC_IMAGE] = KEXEC_KERNEL_CHECK,
>   	[READING_KEXEC_INITRAMFS] = KEXEC_INITRAMFS_CHECK,

