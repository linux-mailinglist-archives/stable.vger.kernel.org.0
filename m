Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBAEE7916C
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 18:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbfG2Quj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 12:50:39 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42824 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726972AbfG2Quj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 12:50:39 -0400
Received: by mail-wr1-f68.google.com with SMTP id x1so12713058wrr.9
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 09:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bKCNDrzNXD8kDs+4Zji72nDWMvbZVJOPeE8sU8hsx8U=;
        b=V4+tkM9mi/h7POp9rz0XeYUxxDjP7AO8PTSH/lh2A6NE5B6k5kOgoE8JQPYDPrvTmz
         qoKJls0uJuldhGWeb89/6ECqToqLvtEKZqkJwkv5AdTJnWnRAAlj0GY34xQk0YMJGI6P
         lOLDZXhSEhxDGrA4ifl8/FzliPpZncHr0XmdGpGM0WIcPcApYX3xI4oCqWs8WzOvlhjI
         atJHkFgGEmI4EU3OLGWWwbS2PYnditX/Urtj4FaEOVDPtf9cGa8hlDr9OYBh2PkFl7yX
         cneEvhlEciCt5y7T6jDcxyF13InZVY1bnkMTT67Oo69X1vYPn5RA703cDEO0HwnM+EGC
         d7+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bKCNDrzNXD8kDs+4Zji72nDWMvbZVJOPeE8sU8hsx8U=;
        b=kHcVp7RXpJcoXLMFaFuKnaVUw9hubBhO/fPyd7zwF/+vwTwBGI0l5lfeEioWvvsCQc
         f7fsQKGnp0hxQ+4TsvPRf9eDl/myhVaiQAJo+vx37nN2jF2k7thW5eEi9BtdjyiBC8T7
         8kOpXben2kislhWq+Zwa4CkrPjCoQ2fklqvrk5c3ZT7SQMa1RzKaaoB1PZf3/A39OCu3
         8ttMP5nvMGTyK73wTjZnwQa/w11FXKaQ+vHrrp5Ie+fVhitHej4YZiRmW0eVh6u6cf8+
         Mi+odWXZaTdsChMqVm5f4K7TPrA+6+K9WiMY4syi2Fqr4Wb17GJax3JRYc4G4hep63Hb
         cBjA==
X-Gm-Message-State: APjAAAV5t8OkPJpAJXZwo0+fCKYJkb9SMNHpfFv3CDPD5+FNzLlqV50j
        3xD0tsa6RHOwcejs2jb6ZIKG/ApwXX2zXvWpS2aeiFVIfTAaVlpz7NGtDJqvAt+3Evkn3dhCxta
        HlEmZK6CDzAX1hKqRpnv7t+XpVfvUNeA4gFnBR+qZgmd6D85LrJn21UN8FWknDfzk5JB4t8G8Dk
        Bfe/Z5+D7otgRquizxLRLMDXc=
X-Google-Smtp-Source: APXvYqylwUI/5u8EudwNXobPmfzrS4MR1Z0EA9B8s0g/aiXdszuFSNDP7MZ5LvyK2ZFS+NOYUKp75Q==
X-Received: by 2002:adf:db50:: with SMTP id f16mr111938020wrj.214.1564419037082;
        Mon, 29 Jul 2019 09:50:37 -0700 (PDT)
Received: from [10.83.36.153] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id z1sm68830259wrv.90.2019.07.29.09.50.36
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 09:50:36 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] iommu/vt-d: Don't queue_iova() if there is
 no flush queue" failed to apply to 4.9-stable tree
To:     gregkh@linuxfoundation.org, baolu.lu@linux.intel.com,
        dwmw2@infradead.org, joro@8bytes.org, jroedel@suse.de,
        stable@vger.kernel.org
References: <1564417154125183@kroah.com>
From:   Dmitry Safonov <dima@arista.com>
Message-ID: <15add355-84d9-69f2-8939-adbf430f8e4f@arista.com>
Date:   Mon, 29 Jul 2019 17:50:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1564417154125183@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CLOUD-SEC-AV-Info: arista,google_mail,monitor
X-CLOUD-SEC-AV-Sent: true
X-Gm-Spam: 0
X-Gm-Phishy: 0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 7/29/19 5:19 PM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

It's not needed for v4.9 stable tree [as pointed by tag's comment line]:

> Cc: <stable@vger.kernel.org> # 4.14+

If there is any better way to inform where a commit should be
backported, please let me know.

I'll send v4.19 -stable patch shortly..
And will prepare v4.14 patch (as we don't have v4.14 release, I need to
actually port it).

Thanks,
          Dmitry
