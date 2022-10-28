Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041BA6108FF
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 05:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235830AbiJ1Dpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 23:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236438AbiJ1DpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 23:45:04 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27FFD8EC8;
        Thu, 27 Oct 2022 20:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1666928629; bh=iF16NPDAFqGPfpt1R4tq9xHi056TkrzLymd9ZzeKhGo=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=tHXtB4rL/AjnT7UbxZ7sLDTQv8IymRvP2l/UTMcZ4wGNKCtNCtCQ1VyMVsgFVTi2h
         aDKP+w2wBj0eQVdQIZHFUwW3C+IcJfgo+9e7+tl7Ajv3dXfWV9uDHAq8PddP6S0XnD
         imj3YpEDRLpo3JuYhLeTUoMlchb+okgBq3wAFpVBn6GAWXLjw5Jy0dqET6y3O5cR+y
         nPoEuaefKj7nmtzB1G0fvlMi7BgbA/PWkwiDGaHvVxxFE0RjgRlhAErem5p6N+iDNE
         122Y7PIh3vmi7idJQXz59ZkHBKwy7S9WJFoOv9NmLocTenJtKUG4aW9bX91PvTGBX8
         Cmaf0Yf8M/vZQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.33.19]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MqJm5-1pRDeh41Bb-00nMqU; Fri, 28
 Oct 2022 05:43:49 +0200
Message-ID: <d0a4472f-e6de-b182-0501-3236aa1b6e69@gmx.de>
Date:   Fri, 28 Oct 2022 05:43:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:3gjgvCVKHuSzMrsGUoH5VkBpJowKvg8nGm+HyGdu3olqxkSSENA
 DS+RnusTRw1is74X0QZ4NB+Tk7b1/bTiFr+8hIX4Iu0rv8751w+ukVnnGFhmn4dGml2/9q0
 wHuWjLjbo/aox1TUC9hxigv5r6GlC7cyDjBuEplBZgyk8LHbrBK1INs/9j0Ewpj8LiESGn5
 tRRmhGPNtKAbDG1ZXQ9Fg==
UI-OutboundReport: notjunk:1;M01:P0:0VIxFcEnz+o=;i5cE8wDwPEqESniOJEEuONsFXSu
 nt6LaEobGT9j3r99DOu0Qb+g5kHBSwfSLr+ZUd/vkuK/ZPUeEfNdBmMut09jMEOvFBVzD+Vac
 1J0XBnNSlphAZd9E0epYKM1M7NoOL8yGvYTyMBQXw0asjz4N3HuKiU6ij5I5GZeBDqRTi3gFw
 xCxqRvaRDAU24NzVU+hKA1OoOhKINgb/5DW/Pgy0cnFHUa2Cl47Ya60gJwp/3jaNMBLUE0HDN
 MTQ9mt4bz+ima2vXfw+LXy+7AjBHEbwUgW/C7+qafXRzWrTMWfsk7/GyACB6fNbEiBN8YyH4B
 IpMoIKL+K8ZDnbnmNUcNufOV9YRfcdmQcT6BnIBsdd00YOMlkmGwhjPsPLEGN4dx/O3E2OiLo
 P75bw2d1Kv+FDESTESwoiGvMrO5Sp5tZkn+sjO9UJ8OGO8u1rO38MpSvI2s39FvF58NVJnkyc
 HDHrW47gNH7UAd+GBgIc+7TeaJMY/iNkM7G8YP9b5ps1kZQnxBzutdAPcmqCMoC2eSd9bntgN
 td9ut5MIoDobixIGTbxRifEgrCibogcirJiwq6p/l6WdPxLO1OS0/tSVZDs47X2vh6QKTu+fj
 J7Wq5cyMFMPd5iMCBmusbxbXCmbUU2+2GvNhO9YmoVyNYDbA39YPKiI3SSFyJ2yh9ZS9uf7zj
 wprUqn9Ts5TktmThEglHrqdj8O0NTgOKNg7RIUquvv9u6uvSrSGBWdjEwu+f179EYOwJ03il0
 nMQLJjS4zfy+juG6iXs7JnrU5g5IkcUUwnNAAXzrEZbSZVngP9TfWXBiLwfA9+oho84cKWeZR
 EL6satmE1Elm8WPgJClL4eLvdnqAhr/1VY3SRQCAmrG++Af+l6Jo3I6pgMOdNO+CUKZyq3oED
 YggU9ZcbOWLRGVEZix/bKAH+iUIPWgtnwOACdg+0JxSnZwvIIWAIOy3spssxw1d6CecRpoFlD
 YYLxZ6wi4FmAOPPDcnNnmdiFxN8=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.0.6-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

