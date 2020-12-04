Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1452CE993
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 09:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgLDI3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 03:29:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728487AbgLDI3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 03:29:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607070454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e9Y6WzFRcgbtIi5LBno88YZfeKK7F+ba+sYdLaKYH9w=;
        b=Gg62bac1lWY9C3nvr1LFQkHRGjzBAKmpYjCuFkyRrbjzmO3uFwoH59bMyTpo4oWUwr+dSi
        WxsaxdpEeJhJDagllXhg4XIEm+M/Lyl9Gjr9sAszWEHm0rf6NFDvspz6YrNy3Gmz4AJY9o
        jVEG81aLGyknba9tOFPv4vnyheAcYAc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-V5UUWpkyPKCn97cbFTYh7A-1; Fri, 04 Dec 2020 03:27:32 -0500
X-MC-Unique: V5UUWpkyPKCn97cbFTYh7A-1
Received: by mail-ej1-f70.google.com with SMTP id h17so1779897ejk.21
        for <stable@vger.kernel.org>; Fri, 04 Dec 2020 00:27:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e9Y6WzFRcgbtIi5LBno88YZfeKK7F+ba+sYdLaKYH9w=;
        b=gGXhcRavsFjH3bbFXABfJC614EV7wm6+zLyUbGq373C6fMByjZ5Cv0eIxLxGy7iWE+
         MyzIDeM0bx/gArcqmko94pjkvqL6gmh7hFjTyEGkK2bX9gSLKZ0EJNgtaD+6DlDbvywE
         Fg6ckdYcD3AXlihaZ6hTEf9im3DVsjk9+qbF0HMiTVeOLzIHE8gpc8h7kd0hrFP0QNq8
         aGBXaJMtTSt1aZ0mdQGqc7nNc3KfvotGdmnRzSoL9Y9gAS9lqqOJMb0mV1npu6DO1gKO
         JxQkY9XoIGsjQXJ3KWqSq71sufHhg+bwDJQ1/hConFAFxJ2HcQ9IQD77s+PA7TlgL1OF
         zxUQ==
X-Gm-Message-State: AOAM53107NceY41X6eNL/PV4Uu3GLNECxP7xMeTJs2k18NwmRCQ5DRN3
        9i3D8u4IrN7iAJHwFoOm4wwhNHK1dvgU7nnt7IRc76WkOQixskKIj6RdrdZj4HDsKkFe/9db/Ak
        kCH5c9H5Ket+VV90i
X-Received: by 2002:a50:e0ce:: with SMTP id j14mr6573304edl.18.1607070451481;
        Fri, 04 Dec 2020 00:27:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwMIyz5LS2iwvNf1iWyhuXSvOdoCaeoLpxIQO9KF7bm/bHa+j5UQfAthZzEj17BWx0cIuFxUQ==
X-Received: by 2002:a50:e0ce:: with SMTP id j14mr6573281edl.18.1607070451200;
        Fri, 04 Dec 2020 00:27:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dh23sm1155140edb.15.2020.12.04.00.27.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 00:27:30 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
To:     Sasha Levin <sashal@kernel.org>
Cc:     Mike Christie <michael.christie@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
 <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
 <20201129210650.GP643756@sasha-vm>
 <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
 <20201130173832.GR643756@sasha-vm>
 <238cbdd1-dabc-d1c1-cff8-c9604a0c9b95@redhat.com>
 <9ec7dff6-d679-ce19-5e77-f7bcb5a63442@oracle.com>
 <4c1b2bc7-cf50-4dcd-bfd4-be07e515de2a@redhat.com>
 <20201130235959.GS643756@sasha-vm>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6c49ded5-bd8f-f219-0c51-3500fd751633@redhat.com>
Date:   Fri, 4 Dec 2020 09:27:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201130235959.GS643756@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/12/20 00:59, Sasha Levin wrote:
> 
> It's quite easy to NAK a patch too, just reply saying "no" and it'll be
> dropped (just like this patch was dropped right after your first reply)
> so the burden on maintainers is minimal.

The maintainers are _already_ marking patches with "Cc: stable".  That 
(plus backports) is where the burden on maintainers should start and 
end.  I don't see the need to second guess them.

Paolo

